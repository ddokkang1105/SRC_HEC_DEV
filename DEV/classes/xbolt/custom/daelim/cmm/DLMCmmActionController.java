package xbolt.custom.daelim.cmm;


import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.*;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.security.cert.X509Certificate;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
/*
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.nets.sso.agent.AuthUtil;
import com.nets.sso.agent.authcheck.AuthCheck;
import com.nets.sso.common.AgentExceptionCode;
import com.nets.sso.common.enums.AuthStatus;
*/
import com.org.json.JSONObject;
import com.rathontech.sso.sp.agent.web.WebAgent;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.daelim.val.DaelimGlobalVal;
import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;
import xbolt.wf.web.WfActionController;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
/**
 * 
 * @Class Name : DLMActionController.java
 * @Description : Daelim WF Action Controller
 * @since 2024. 08. 02.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class DLMCmmActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
		
	@RequestMapping(value = "/custom/daelim/logindlmForm.do")
	public String logindlmForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		model = setLoginScrnInfo(model, cmmMap);
		model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
		model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
		model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
		model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
		model.put("esType", StringUtil.checkNull(cmmMap.get("esType")));
		model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
		model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal")));
		model.put("status", StringUtil.checkNull(cmmMap.get("status")));
		
		return nextUrl("/custom/daelim/cmm/login");
	}

	@RequestMapping(value = "/custom/daelim/logindlm.do")
	public String logindlmc(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			
			HttpSession session = request.getSession(true);
			Map resultMap = new HashMap();
			String langCode = GlobalVal.DEFAULT_LANG_CODE;
			String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),
					StringUtil.checkNull(cmmMap.get("LANGUAGEID")));
			if (languageID.equals("")) {
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}

			cmmMap.put("LANGUAGE", languageID);
			String ref = request.getHeader("referer");
			//String protocol = request.isSecure() ? "https://" : "http://";

			String IS_CHECK = GlobalVal.PWD_CHECK;
			//String url_CHECK = StringUtil.chkURL(ref, "https");
			String url_CHECK = StringUtil.chkURL(ref, "http");

			if ("".equals(IS_CHECK))
				IS_CHECK = "Y";

			if ("".equals(url_CHECK)) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT,
						"Your ID does not exist in our system. Please contact system administrator(DL Chemical).");
			} else {

				Map idInfo = new HashMap();

				if ("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
					cmmMap.put("IS_CHECK", "Y");
				} else {
					cmmMap.put("IS_CHECK", "N");
				}

				idInfo = commonService.select("login_SQL.login_id_select", cmmMap);

				if (idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					// resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
				} else {
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId")); // parameter LOGIN_ID 는 사번이므로 조회한 LOGINID로 put
					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if (loginInfo == null || loginInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						// resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));
					} else {
						// [Authority] < 4 인 경우, 수정가능하게 변경
						if (loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)
							loginInfo.put("loginType", "editor");
						else
							loginInfo.put("loginType", "viewer");
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
						// resultMap.put(AJAX_MESSAGE, "Login성공");
						session.setAttribute("loginInfo", loginInfo);
					}
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
				model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
				model.put("esType", StringUtil.checkNull(cmmMap.get("esType")));
				model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
				model.addAttribute(AJAX_RESULTMAP, resultMap);
			}
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("LoginActionController::loginbase::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap) throws Exception {
		String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		model.addAttribute("loginid", StringUtil.checkNull(cmmMap.get("loginid"), ""));
		model.addAttribute("pwd", pass);
		model.addAttribute("lng", StringUtil.checkNull(cmmMap.get("lng"), ""));

		if (_log.isInfoEnabled()) {
			_log.info("setLoginScrnInfo : loginid=" + StringUtil.checkNull(cmmMap.get("loginid")) + ",pass"
					+ URLEncoder.encode(pass) + ",lng=" + StringUtil.checkNull(cmmMap.get("lng")));
		}
		List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
		if (langList != null && langList.size() > 0) {
			for (int i = 0; i < langList.size(); i++) {
				Map langInfo = (HashMap) langList.get(i);
				if (langInfo.get("IsDefault").equals("1")) {
					model.put("langType", StringUtil.checkNull(langInfo.get("CODE"), ""));
					model.put("langName", StringUtil.checkNull(langInfo.get("NAME"), ""));
				}
			}
		} else {
			model.put("langType", "");
			model.put("langName", "");
		}
		model.put("langList", langList);
		model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
		return model;
	}

	// DL SSO Spell 오류 >> eclick sso url 제등록 필요
	@RequestMapping(value = "/custom/daelim/indexDLMC.do")
	public String indexDLMC(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
            
			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");

			// 환경설정 시작
			// String SSO_URL = "https://gw.daelimcloud.com/WebSite/Login.aspx";
			// 환경설정 끝

			// 기본변수 끝
			String ssoEmp = "";
			String olmI = "";

			// 인증 시작
			WebAgent agent = new WebAgent(); // agent 호출
			agent.requestAuthentication(request, response);

			ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_USER_ID"));
			// ssoEmp 없으면 sso 로그인 페이지
			if (!"".equals(ssoEmp) && ssoEmp != null) {
				/*
				 * if(agent.requestAuthentication(request, response,false)){ 
				 * //인증처리 필요 (DL 그룹웨어로
				 * 이동) if(!response.isCommitted()) { //response.sendRedirect(SSO_URL); } } else
				 * {
				 * 
				 * }
				 */
				// SSO 인증완료
				olmI = ssoEmp;
			}

			model.put("olmI", olmI);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DLMCActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/indexEClick");
	}	
	
	// DL 그룹 공통 SSO
	@RequestMapping(value = "/custom/daelim/indexDLM.do")
	public String indexDLM(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
            
			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");

			// 환경설정 시작
			// String SSO_URL = "https://gw.daelimcloud.com/WebSite/Login.aspx";
			// 환경설정 끝

			// 기본변수 끝
			String ssoEmp = "";
			String olmI = "";

			// 인증 시작
			WebAgent agent = new WebAgent(); // agent 호출
			agent.requestAuthentication(request, response);

			//ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_PERSON_NO"));// 접속 서용자 사번
			ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_USER_ID"));// 접속 사용자 ID
			
			// ssoEmp 없으면 sso 로그인 페이지
			if (!"".equals(ssoEmp) && ssoEmp != null) {
				/*
				 * if(agent.requestAuthentication(request, response,false)){ 
				 * //인증처리 필요 (DL 그룹웨어로
				 * 이동) if(!response.isCommitted()) { //response.sendRedirect(SSO_URL); } } else
				 * {
				 * 
				 * }
				 */
				// SSO 인증완료
				olmI = ssoEmp;
		        if (olmI.startsWith("dae")) {
		        	olmI = olmI.substring(3);  // 앞의 dae 제거
		        }
			}
			
			model.put("olmI", olmI);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
			model.put("srType", StringUtil.checkNull(cmmMap.get("srType"), ""));
			model.put("esType", StringUtil.checkNull(cmmMap.get("esType"), ""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));

		} catch (Exception e) {
			System.out.println(e);
			if (_log.isInfoEnabled()) {
				_log.info("DLMCActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/indexDLM");
	}	
	
	@RequestMapping(value = "/custom/daelim/indexDL.do")
	public String indexDL(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
            
			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");

			// 환경설정 시작
			// String SSO_URL = "https://gw.daelimcloud.com/WebSite/Login.aspx";
			// 환경설정 끝

			// 기본변수 끝
			String ssoEmp = "";
			String olmI = "";

			// 인증 시작
			WebAgent agent = new WebAgent(); // agent 호출
			agent.requestAuthentication(request, response);

			//ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_PERSON_NO"));// 접속 서용자 사번
			ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_USER_ID"));// 접속 사용자 ID
			
			// ssoEmp 없으면 sso 로그인 페이지
			if (!"".equals(ssoEmp) && ssoEmp != null) {
				/*
				 * if(agent.requestAuthentication(request, response,false)){ 
				 * //인증처리 필요 (DL 그룹웨어로
				 * 이동) if(!response.isCommitted()) { //response.sendRedirect(SSO_URL); } } else
				 * {
				 * 
				 * }
				 */
				// SSO 인증완료
				olmI = ssoEmp;
		        if (olmI.startsWith("dae")) {
		        	olmI = olmI.substring(3);  // 앞의 dae 제거
		        }
			}
			
			model.put("olmI", olmI);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
			model.put("srType", StringUtil.checkNull(cmmMap.get("srType"), ""));
			model.put("esType", StringUtil.checkNull(cmmMap.get("esType"), ""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));

		} catch (Exception e) {
			System.out.println(e);
			if (_log.isInfoEnabled()) {
				_log.info("DLMCActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/indexDLM");
	}
	
	// DL ITSM Eclick 전용 SSO
	@RequestMapping(value = "/custom/daelim/indexEClick.do")
	public String indexEClick(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
            
			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");

			// 환경설정 시작
			// String SSO_URL = "https://gw.daelimcloud.com/WebSite/Login.aspx";
			// 환경설정 끝

			// 기본변수 끝
			String ssoEmp = "";
			String olmI = "";

			// 인증 시작
			WebAgent agent = new WebAgent(); // agent 호출
			agent.requestAuthentication(request, response);

			//ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_PERSON_NO"));// 사원번호
			ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_USER_ID"));// 사원번호
			
			// dl enc의 경우 사원번호로 로그인
			boolean checkENC = ssoEmp.toUpperCase().contains("DAE");
	        if (checkENC) {
	        	ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_PERSON_NO"));// 사원번호
				
	        }
			
			// ssoEmp 없으면 sso 로그인 페이지
			if (!"".equals(ssoEmp) && ssoEmp != null) {
				/*
				 * if(agent.requestAuthentication(request, response,false)){ 
				 * //인증처리 필요 (DL 그룹웨어로
				 * 이동) if(!response.isCommitted()) { //response.sendRedirect(SSO_URL); } } else
				 * {
				 * 
				 * }
				 */
				// SSO 인증완료
				olmI = ssoEmp;
			}
			
			model.put("olmI", olmI);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
			model.put("srType", StringUtil.checkNull(cmmMap.get("srType"), ""));
			model.put("esType", StringUtil.checkNull(cmmMap.get("esType"), ""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));

		} catch (Exception e) {
			System.out.println(e);
			if (_log.isInfoEnabled()) {
				_log.info("DLMCActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/indexEClick");
	}	
	
	@RequestMapping(value="/logoutEClick.do")
	public String logoutEClick(ModelMap model, HashMap cmmMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession(true);
		session.invalidate();
		return nextUrl(AJAXPAGE);
	}
	
	// Approval Request 
	@RequestMapping("/zDlm_wfDocMgt.do")
	public String zDlm_wfDocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception {
		String url = "";//DaelimGlobalVal.DLM_WF_URL;
	
		String customerNo = StringUtil.checkNull(request.getParameter("customerNo"));
		String actionType = StringUtil.checkNull(request.getParameter("actionType"),"");
		String inhouse = StringUtil.checkNull(request.getParameter("inhouse"),"");
		
		model.put("menu", getLabel(request, commonService)); 
		
		if(actionType.equals("create")) {			
			// inhouse = Y -> 전자결재  /zDlm_apvrMgt.do로 리다이렉션
		    if ("Y".equals(inhouse)) { 
		    	StringBuilder redirectUrl = new StringBuilder("/zDlm_aprvMgt.do");

		        // commandMap의 모든 키-값 쌍을 쿼리 파라미터로 추가
		    	boolean firstParam = true;
		        for (Object key : commandMap.keySet()) {
		            String value = StringUtil.checkNull(commandMap.get(key));
		            if (firstParam) {
		                redirectUrl.append("?").append(key).append("=").append(URLEncoder.encode(value, "UTF-8"));
		                firstParam = false; // 첫 번째 파라미터 사용 후 false로 변경
		            } else {
		                redirectUrl.append("&").append(key).append("=").append(URLEncoder.encode(value, "UTF-8"));
		            }
		        }
		        System.out.println("redirectUrl:"+redirectUrl);
		        // 리디렉션
		        response.sendRedirect(redirectUrl.toString());
		        return null; // 리디렉션 후 추가 처리가 없으므로 null 반환
		   
		    }else { // olm 결재
		   
			url = StringUtil.checkNull(commandMap.get("WFDocURL"));
			zDlm_createWfDoc_SR(request, commandMap, model);
			
		    }
		} else if(actionType.equals("view")) {
			
			model = zDlm_getApprovalMailForm(request, commandMap, model);				
			url = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAprURL", commandMap));
			if(url.equals("")) url = "/custom/daelim/itsm/zDlm_approvalDetail"; 
		}
		
		return nextUrl(url);
	}
	
	public static String extractBeforeDelimiter(String input, String delimiter) {
        // 주어진 구분자 앞의 부분을 추출
        int delimiterIndex = input.indexOf(delimiter);
        if (delimiterIndex != -1) {
            return input.substring(0, delimiterIndex).trim();
        } else {
            // 구분자가 없으면 원본 문자열 그대로 반환
            return input;
        }
    }
	
	// Approval Request GW
	// https://gw.daelimcloudtest.com/WebSite/Approval/Controls/WfWebService/CreateDoc.asmx?op=CreateDocument
	@RequestMapping(value = "/zDlm_aprvMgt.do")
	public String zDlm_aprvMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/WebSite/Approval/Controls/WfWebService/CreateDoc.asmx?op=CreateDocument";
		
		//https://gw.daelimcloudtest.com/WebSite/Approval/Controls/WfWebService/CreateDoc.asmx?op=CreateDocument
		String actionType = StringUtil.checkNull(request.getParameter("actionType"),"");
		HashMap target = new HashMap();
		if(actionType.equals("create")) {
			
			// SR 요청자 
			String approverIDMemberID = StringUtil.checkNull(commandMap.get("srRequestUserID"));
			String category = StringUtil.checkNull(commandMap.get("category"));
			String subCategory = StringUtil.checkNull(commandMap.get("subCategory"));
			
			// 1. 결재 중복 체크 
	    	Map<String, Object> setData = new HashMap<>();
			setData.put("documentNo", StringUtil.checkNull(request.getParameter("srCode")));
    		setData.put("documentID", StringUtil.checkNull(request.getParameter("documentID")));
    		setData.put("status", "0");
			// Select WFInstanceID From XBOLTADM.TB_WF_INST Where DocumentID = 2009 And DocumentNo = 'ACM2411133' And Status = 0
    		String wfInstacceID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfInstanceID", setData));
			
			if(!wfInstacceID.equals("")) { // 이미 상신 데이터가 있으면 리턴 //재상신로직도 확인하기 
				System.out.println("이미 결재가 진행중!!");
				target.put(AJAX_ALERT, "결재가 이미 진행중 입니다.");
				model.addAttribute(AJAX_RESULTMAP, target);
    			return nextUrl(AJAXPAGE);
			}
			
		
			/*  ASIS 설명 
			 * 쿼리를 먼저 조회하고 2선처리자를 전자결재 생성자에 넣고 아래 쿼리를 조회해서 등록자가 존재하면 전자결재 생성자에 변경 
			 */
			// AP변경 의뢰유형이 오류인 경우 변경계획수립 단계의 전자결재는 요청자가 아닌 담당자한테 전자결재가 생성되야함
			// AP변경 + RCP300002(오류조치), ADD120102 인 경우
			
			if(!StringUtil.checkNull(commandMap.get("speCode")).equals("ACM0010")) { // 배포부서 승인이 아니면
				if("RCP020".equals(category) || "RCP030".equals(category)) { // 장애등록/신고,오류신고( REQ Cat)
					commandMap.put("speCode", "REQ0004"); // IT담당자 처리 pre actor 
					commandMap.put("preCategory", "'RCP020','RCP030','RDT120'"); // IT담당자 처리 pre actor 
					String preCatActor = StringUtil.checkNull(commonService.selectString("esm_SQL.getActorIDNoByPreCat",commandMap)); 
					if(!preCatActor.equals("")) {
						approverIDMemberID = preCatActor;
					}
				}
				
				//ADD100101 현업요청>오류조치, ADD120102 현업요청>오류조치 , RCP302003 운영초치>오류조치, RCP300002:요청사항>오류조치 
				if("RCP300002".equals(subCategory) || "ADD120102".equals(subCategory) || "ADD100101".equals(subCategory) || "RCP302003".equals(subCategory)){ // ACM 오류조치 						
					approverIDMemberID =  StringUtil.checkNull(commandMap.get("actorID"));
				}
			} 
			
			if(StringUtil.checkNull(commandMap.get("speCode")).equals("ACM0010")) { // ACM 배포 부서 승인이면 : 담당자는 기존 이클릭 기준으로 해당 단계의 담당(접수)자
				approverIDMemberID =  StringUtil.checkNull(commandMap.get("actorID"));
			}
			
			/*
			if("RCP300002".equals(category) || "ADD120102".equals(category)){
				commandMap.put("speCode", "REQ0004"); // IT담당자 처리 pre actor 
				commandMap.put("preCategory", "'RCP020','RCP030','RDT120'"); // IT담당자 처리 pre actor 
				String preCatActor = StringUtil.checkNull(commonService.selectString("esm_SQL.getActorIDNoByPreCat",commandMap)); 
				if(!preCatActor.equals("")) {
					approverIDMemberID = preCatActor;
				}
			}
			*/
			
			commandMap.put("memberID",approverIDMemberID);
			Map requestUserInfo = commonService.select("user_SQL.getMemberInfo", commandMap);
			
			String approverID = "";
			String approverClientID = "";
			String approverTeamCode = "";
			if(!requestUserInfo.isEmpty()) {
				approverID = StringUtil.checkNull(requestUserInfo.get("LoginID"));
				approverClientID = StringUtil.checkNull(requestUserInfo.get("ClientID"));
				
				// * DLENC 는 사번으로 전달 
				if("0000000008".equals(approverClientID)){
					approverID = StringUtil.checkNull(requestUserInfo.get("EmployeeNum"));
				}
				
				approverTeamCode = StringUtil.checkNull(requestUserInfo.get("TeamCode"));
			}
			
			commandMap.put("approverID", approverID);
			commandMap.put("approverTeamCode", approverTeamCode);
			commandMap.put("approverClientID", approverClientID);
			
			String pid = zDlm_createWfDoc_GW(request, commandMap, model); // tb_wf_inst, tb_wf_step_inst 생성 및  GW pid 발급 요청
			//String pid = "2F6878DCE81946D8B04C191E908B6D9C"; // ACM241018024207 ECLICK.AP_CHANGE
		
			System.out.println(" 전자결재 생성 요청전 pid :"+pid );
			
			if(!pid.equals("")) {
				HashMap apprMap = new HashMap();
				apprMap.put("pid", pid);
				//apprMap.put("sessionUserID", "DCP30003150");	
				//approverID = "DCP30003150"; // 테스트 user(김현명) 적용시 필수 확인 
				apprMap.put("approverID", approverID);
				
				HashMap returnCreateDocDataMap = connGroupWareWF(apprMap,url,"createWFDocumentXML"); // S/F
				System.out.println("returnCreateDocDataMap :"+ returnCreateDocDataMap);
				
				if(!returnCreateDocDataMap.isEmpty()) {
					if(StringUtil.checkNull(returnCreateDocDataMap.get("RTN")).equals("ERROR")) {
						// target.put(AJAX_ALERT, StringUtil.checkNull(returnCreateDocDataMap.get("ERROR_MSG"))); // ERROR_MSG
						String ERROR_MSG = StringUtil.checkNull(returnCreateDocDataMap.get("ERROR_MSG"));						
						String DES = StringUtil.checkNull(returnCreateDocDataMap.get("DES"));
						
						String retrunMsg = DES;
						String extract_errMsg = extractBeforeDelimiter(ERROR_MSG, "/////");
						if(!extract_errMsg.equals("")) {
							retrunMsg = extract_errMsg;
						}
						
						target.put(AJAX_ALERT, retrunMsg); 
						//target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
						
					} else {
						target.put(AJAX_ALERT, "승인 요청이 완료 되었습니다."); // DES
						target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
					}
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				} else { // GW CreateDoc 요청 실패 
					target.put(AJAX_ALERT, "전자결재 생성 요청중 오류가 발생하였습니다."); 
					target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
				
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				}
				
			} else { // GW 연결 오류 
				target.put(AJAX_ALERT, "승인 요청 중 오류가 발생되었습니다."); 
				target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
			
				model.addAttribute(AJAX_RESULTMAP, target);
				return nextUrl(AJAXPAGE);
				
			}
		} 
		
		return "resultView";
	}

	public String zDlm_createWfDoc_SR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String srID = StringUtil.checkNull(request.getParameter("srID"),"");
		String speCode = StringUtil.checkNull(request.getParameter("speCode"),"");
		String defWFID = StringUtil.checkNull(request.getParameter("defWFID"),"");
		String activityLogID = StringUtil.checkNull(request.getParameter("activityLogID"),"");
		String showInvisible = StringUtil.checkNull(request.getParameter("showInvisible"),"");
		String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"");
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),"");
		
		Map setMap = new HashMap();
		setMap.put("srID", srID);
		setMap.put("languageID", languageID);
		Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setMap);	
		model.put("srInfo", srInfo);
		
		setMap = new HashMap();
		setMap.put("speCode", speCode);
		setMap.put("srID", srID);
		setMap.put("languageID", languageID);
		setMap.put("activityLogID", activityLogID);
		Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setMap);
	
		model.put("activityLogInfo", activityLogInfo);
		model.put("srID", srID);
		
		//========================= 결재선 start===============================================
		if("".equals(defWFID)) {
			setMap.put("wfDocType", docCategory); // docCategory
			setMap.put("docSubClass", StringUtil.checkNull(request.getParameter("docSubClass"),"")); 
			defWFID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFIDForTypeCode", setMap));
		}

		setMap.put("WFID",defWFID); model.put("wfID",defWFID);
		String stepName = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFURL", setMap)); // zDlm_wfPathITSM
		commandMap.put("funcType",stepName);
		
		HashMap returnMap = WfActionController.wfPathMgt(model,commandMap,request);
		String memberIDs = StringUtil.checkNull(returnMap.get("memberIDs"));
		String roleTypes = StringUtil.checkNull(returnMap.get("roleTypes"));		
		String wfStepInfo = StringUtil.checkNull(returnMap.get("wfStepInfo"));
		
		model.put("wfStepMemberIDs", memberIDs);
		model.put("wfStepRoleTypes", roleTypes);
		model.put("wfStepInfo", wfStepInfo);
		//==========================결재선 end ==================================================
		
		// ========================= 본문 Start=================================================
		// attrTypeCode alloc list 
		//String inhouse = StringUtil.checkNull(commandMap.get("inhouse"));
		//if(inhouse.equals("Y")) {
			setMap = new HashMap();
			setMap.put("srID", srID);
			setMap.put("speCode", StringUtil.checkNull(srInfo.get("Status")));
			setMap.put("srType", StringUtil.checkNull(srInfo.get("SRType")));
			
			setMap.put("languageID", languageID);
			setMap.put("docCategory", "SR");
			setMap.put("showInvisible", showInvisible);
				
			// SR ATTR		
			List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttrList", setMap);
			srAttrList = ESPUtil.getSRAttrList(commonService, srAttrList, setMap, languageID);
			
			String description =  "";
			if(srAttrList.size()>0) {
				for(int i=0; i<srAttrList.size(); i++) {
					Map attrInfo = (Map)srAttrList.get(i);
					if( !StringUtil.checkNull(attrInfo.get("PlainText")).equals("")) {
						description += "<BR>"+ StringUtil.checkNull(attrInfo.get("Name")) + " : " +StringUtil.checkNull(attrInfo.get("PlainText"));
					}
				}
				description += "&lt;br&gt;&lt;br&gt;";
			}
			
			model.put("description", description);
		//}
		// ========================= 본문 End==================================================
		
		model.put("isPop","Y");
		model.put("docSubClass", StringUtil.checkNull(commandMap.get("docSubClass")));
		model.put("docCategory", StringUtil.checkNull(commandMap.get("docCategory")));
		
		return "";
	}
	
	// 전자시 olm 결재 dadta 생성, pid 조회 하여 리턴 
	public String zDlm_createWfDoc_GW(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap setData = new HashMap();
		HashMap insertWFInstData = new HashMap();
		
		//String projectID = StringUtil.checkNull(commandMap.get("projectID"));
		String docSubClass = StringUtil.checkNull(commandMap.get("docSubClass"));
		String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
		String wfID = StringUtil.checkNull(commandMap.get("defWFID"),"");
		String srCode = StringUtil.checkNull(commandMap.get("srCode"));
		String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
		
		//승인요청시 중복 생성 방지를 위해
														
		setData.put("wfID", wfID);	
		
		String reqReApprovalYN =  StringUtil.checkNull(commandMap.get("reqReApproval"));
		
		if(!reqReApprovalYN.equals("Y")) { // 재요청이 아닐경우 신규생성
			//SET NEW WFInstance ID
			String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setData);
			String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
			int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();	
			String initLen = "%0" + (13-OLM_SERVER_NAME_LENGTH) + "d";
			
			int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
			int maxcode = maxWFInstanceID2 + 1;
			String newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);
	
			wfInstanceID = newWFInstanceID;
			setData.put("wfID",wfID);
			setData.put("wfDocType",docCategory);
			setData.put("docSubClass",docSubClass);
			
			String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAllocID", setData));
	
			commandMap.put("wfID",wfID);
			commandMap.put("newWFInstanceID",newWFInstanceID);
			commandMap.put("wfAllocID",wfAllocID);
					
			commandMap.put("wfStepMemberIDs", StringUtil.checkNull(commandMap.get("sessionUserId")));
			commandMap.put("wfStepRoleTypes", "AREQ");
			commandMap.put("wfStepInfo", StringUtil.checkNull(commandMap.get("sessionUserNm")));
			
			// SR MST
			setData.put("srID", StringUtil.checkNull(commandMap.get("srID")));
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);	
			
			// Activity Log Info 
			setData.put("activityLogID", StringUtil.checkNull(commandMap.get("activityLogID")));
			Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setData);
			
			String subject = "[eClick 전자결재 요청]" +  activityLogInfo.get("ActivityName") + "(" + srInfo.get("Subject") + ")"; // [eClick 전자결재 요청] ${activityLogInfo.ActivityName}(${srInfo.Subject})
			if(StringUtil.checkNull(commandMap.get("asisEclick")).equals("Y")){
				subject = "[AS-IS eClick 전자결재 요청]" +  activityLogInfo.get("ActivityName") + "(" + srInfo.get("Subject") + ")";
			}
			commandMap.put("subject", subject);
			
			// 결재 본문 
			setData.put("speCode", StringUtil.checkNull(srInfo.get("Status")));
			setData.put("srType", StringUtil.checkNull(srInfo.get("SRType")));
			
			setData.put("docCategory", "SR");
			setData.put("showInvisible", StringUtil.checkNull(commandMap.get("showInvisible")));
				
			// SR ATTR		
			List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttrList", setData);
			srAttrList = ESPUtil.getSRAttrList(commonService, srAttrList, setData, StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			
			String description =  "";
			if(srAttrList.size()>0) {
				for(int i=0; i<srAttrList.size(); i++) {
					Map attrInfo = (Map)srAttrList.get(i);
					if( !StringUtil.checkNull(attrInfo.get("PlainText")).equals("")) {
						description += "&lt;br&gt;"+ StringUtil.checkNull(attrInfo.get("Name")) + " : " +StringUtil.checkNull(attrInfo.get("PlainText"));
					}
				}
				description += "&lt;br&gt;&lt;br&gt;";
			}
			
			commandMap.put("description", description);
			
			// 결재 정보 생성 
			if(!StringUtil.checkNull(commandMap.get("speCode")).equals("ACM0010")) { commandMap.put("aprvOption", "POST"); }  // 배포부서 승인요청이 아니면 aprvOption : POST 로 insert 
			insertWFInstData = insertWFStepInst(request,commandMap,model); // -1
			
			// asis eclick 전자결재 생성  activiy log 에 wfInstanceID update 
			if(StringUtil.checkNull(commandMap.get("asisEclick")).equals("Y")){
				commandMap.put("PID", StringUtil.checkNull(commandMap.get("srID")));
				commandMap.put("SpeCode", StringUtil.checkNull(commandMap.get("speCode"))); 
				commandMap.put("WFInstanceID",newWFInstanceID);
				commonService.update("esm_SQL.updateActivityLog", commandMap);
			}
		
		}
		
		// 1.전자결재 PID 발급 요청 
		HashMap apprMap = new HashMap();
		//apprMap.put("Lowidticket", "ACM240906024185");
		apprMap.put("Lowidticket", srCode);
		apprMap.put("sKey", UUID.randomUUID().toString());
		apprMap.put("wfInstanceID", wfInstanceID);
				
		apprMap.put("TargetUserId", commandMap.get("approverID")); 
		apprMap.put("TargetUserDeptId", commandMap.get("approverTeamCode")); 
		apprMap.put("sessionUserId", commandMap.get("approverID")); 
		
		// DCP30003150 DCP20000458	
	    String approverClientID = StringUtil.checkNull(commandMap.get("approverClientID"));
		String formid = "WF_FORM_ECLICK_NEW";
		String srType = StringUtil.checkNull(commandMap.get("speCode")).substring(0, 3);
		System.out.println("WF_FORM_ECLICK_NEW3 logic srType :"+srType);
		if(StringUtil.checkNull(commandMap.get("speCode")).equals("ACM0010")) {// AP 변경적용용청 (배포는 AP변경적용요청만 있으므로 나머지는 전부 WF_FORM_ECLICK_NEW)
			formid = "WF_FORM_ECLICK_NEW2";
		} else if("0000000007".equals(approverClientID) && "ACM".equals(srType)) { // 20251024 DL Chemical ( 0000000007 ) 요청부서 결재일경우는 WF_FORM_ECLICK_NEW3
			formid = "WF_FORM_ECLICK_NEW3";
		}
		System.out.println("formid :"+formid);
		
		System.out.println("approverClientID:"+approverClientID+"/  formid => "+formid);
		
		apprMap.put("formid", formid);
		
		String reqUrl = "/WebSite/Approval/Controls/ApprovalWebService.asmx?op=SetLegacyInstance";	// https://gw.daelimcloud.com
		HashMap pidMap = connGroupWareWF(apprMap,reqUrl,"createSetLegacyInstXML"); 
		
		String pid = "";
		if(!pidMap.isEmpty()) {
			pid =  StringUtil.checkNull(pidMap.get("pid"));
		}
		System.out.println("pid :"+ pid);
		
		/*** 결재 상태값
    	--> 승인요청시 wf_inst.status = -1 (GW 진행중)
    	--> pid 리턴시 wf_inst.status : 0 (임시저장)
    	--> GW화면에서 submit 시 wf_inst.status : 1 (결재 진행중 (상신 및 승인 최종결재전까지))
    	--> 최종 결재시 wf_inst.status  2  or 3 나머지는 path 에 update
    	 */
		if(!pid.equals("")) {
			setData.put("WFInstanceID", wfInstanceID);
			setData.put("ReturnedValue", pid);
			setData.put("Status", "0");
			setData.put("LastUser", commandMap.get("sessionUserId"));
			if(StringUtil.checkNull(commandMap.get("asisEclick")).equals("Y")){
				setData.put("Comment", "asisEclick");
			}
			commonService.update("wf_SQL.updateWfInst", setData);
		}
		
		return pid;
	}

	@RequestMapping(value = "/zDlm_submitWfInst.do")
	public String zDlm_submitWfInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
				HashMap setData = new HashMap();
				HashMap setMap = new HashMap();
				HashMap insertWFInstData = new HashMap();
				
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String docSubClass = StringUtil.checkNull(commandMap.get("docSubClass"));
				String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"),"");
																
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
				setData.put("wfDocType",docCategory);
				setData.put("docSubClass",docSubClass);
				
				String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAllocID", setData));

				commandMap.put("wfID",wfID);
				commandMap.put("newWFInstanceID",newWFInstanceID);
				commandMap.put("wfAllocID",wfAllocID);
				
				// 결재 정보 생성 
				insertWFInstData = insertWFStepInst(request,commandMap,model);
				
				setMap.put("s_itemID", projectID);
				
				commandMap.put("insertWFInstData",insertWFInstData);

				commandMap.put("lastSeq",insertWFInstData.get("lastSeq"));
	
				// Activity Update
				ESPUtil.srAprvProcessingMaster(request,commonService,commandMap);
		
				commandMap.put("emailType", "SRAPREQ");
				// 결재 상신 Email 전송
				//sendWfMail(request,commandMap,model);

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
		HashMap insertWFInstData = new HashMap();
		try {
				
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID")); // activityLogID
				String documentNo = StringUtil.checkNull(commandMap.get("documentNo")); // SRCODE
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String creatorTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"));
				String docCategory = StringUtil.checkNull(commandMap.get("docCategory"),"");
				String description = StringUtil.checkNull(commandMap.get("description"));
				String wfAllocID = StringUtil.checkNull(commandMap.get("wfAllocID"));
				String subject = StringUtil.checkNull(commandMap.get("subject"));
				String newWFInstanceID = StringUtil.checkNull(commandMap.get("newWFInstanceID"));
				String inhouse = StringUtil.checkNull(commandMap.get("inhouse"));
				
				String getWfStepMemberIDs = StringUtil.checkNull(commandMap.get("wfStepMemberIDs"));
				String getWfStepRoleTypes = StringUtil.checkNull(commandMap.get("wfStepRoleTypes"));
				
				String wfStepMemberIDs[] = null;
				String wfStepRoleTypes[] = null;
				String wfStepSeq[] = null;
				
				if(!getWfStepMemberIDs.isEmpty()){ wfStepMemberIDs = getWfStepMemberIDs.split(","); }
				if(!getWfStepRoleTypes.isEmpty()){ wfStepRoleTypes = getWfStepRoleTypes.split(","); wfStepSeq = getWfStepRoleTypes.split(",");}
				
				// SET APRV PATH	
				int idx = 0;
									
				for(int j=0; j< wfStepRoleTypes.length; j++){	
					if(j == 0){						
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
				String status = "1";
				if(inhouse.equals("Y")) status = "-1"; //내부 전자결재
				
				// gw 호출시 wf_inst.status = -1 --> pid 리턴시 : 0 --> submit 시 결재 진행중 update 1 -----> 최종 결재시 2  or 3 나머지는 path 에 update
				//INSERT NEW WF Instance
				insertWFInstData.put("WFInstanceID", newWFInstanceID);
				insertWFInstData.put("ProjectID", projectID);
				insertWFInstData.put("DocumentID", documentID);
				insertWFInstData.put("DocumentNo", documentNo);
				insertWFInstData.put("DocCategory", docCategory);
				insertWFInstData.put("WFID", wfID);
				insertWFInstData.put("Creator", loginUser);
				insertWFInstData.put("LastUser", loginUser);
				insertWFInstData.put("Status", status); // 상신
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
											
						status = null ;
						
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
	
	public HashMap connGroupWareWF(HashMap<String, String> apprMap,String reqUrl, String createXML) throws Exception {
		String domain = DaelimGlobalVal.DLM_GW_URL + reqUrl; //https://gw.daelimcloudtest.com
        HashMap returnDataMap = new HashMap();

        try {
        	
        	System.out.println("domain :"+domain+", createXML:"+createXML);
            URL url = new URL(null, domain, new sun.net.www.protocol.https.Handler());
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();

            conn.setConnectTimeout(50000);
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Accept-Charset", "utf-8");
            conn.addRequestProperty("Content-Type", "text/xml; charset=utf-8");
            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream(), "utf-8");      
            
            
            String xmlDoc = "";
            String returnParam = "";
            if(createXML.equals("createSetLegacyInstXML")) {
            	xmlDoc = createWFSetLegacyInstXML(apprMap); // 1.PID 생성 요청
            	returnParam = "PID";
            	//System.out.println(xmlDoc);
                wr.write(xmlDoc); // 생성된 XML을 HTTP 요청 본문에 씀
                wr.flush(); // 데이터를 실제로 전송
                             
                String pid = readDocumentWfXML(conn.getInputStream(), returnParam);
                returnDataMap.put("pid", pid);
                
            }else if(createXML.equals("createWFDocumentXML")) {
            	xmlDoc = createWFDocumentXML(apprMap); // 2. 전자결재 생성 요청
            	returnParam = "ReturnCode";
            	//System.out.println(xmlDoc);
                wr.write(xmlDoc);
                wr.flush();
                                
                returnDataMap = readDocumentWfXMLV2(conn.getInputStream());
                System.out.println("returnDataMap :"+returnDataMap);                
               
            }
           
            
            wr.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
        return returnDataMap;
	}
	
	// 1.전자결재 PID 생성요청  XML 
	public String createWFSetLegacyInstXML(HashMap apprMap) throws Exception {
		String returnData = "";
		String formid = StringUtil.checkNull(apprMap.get("formid"));
		try {
			String xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
						+"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
						+"<soap:Body>"
						+"<SetLegacyInstance xmlns=\"http://tempuri.org/\">"
						//+"<sKeys><![CDATA["+StringUtil.checkNull(apprMap.get("Lowidticket"))+"/"+StringUtil.checkNull(apprMap.get("sKey"))+"]]></sKeys>"
						+"<sKeys><![CDATA["+StringUtil.checkNull(apprMap.get("wfInstanceID")) + "]]></sKeys>"
						+"<sFormId><![CDATA["+StringUtil.checkNull(formid)+"]]></sFormId>"
						+"<sUserID><![CDATA["+StringUtil.checkNull(apprMap.get("TargetUserId"))+"]]></sUserID>"
						+"<sDeptID><![CDATA["+StringUtil.checkNull(apprMap.get("TargetUserDeptId"))+"]]></sDeptID>"
						+"<sSubject><![CDATA[eClick 전자 결재 요청]]></sSubject>"
						+"</SetLegacyInstance>"
						+"</soap:Body>"
						+"</soap:Envelope>";
			  
			byte[] str = xml.getBytes("utf-8");
			System.out.println("createWFSetLegacyInstXML :"+xml);
			 
			returnData = new String(str,"utf-8");
				        
		} catch (Exception e) {
			e.printStackTrace();
		}    
		return returnData;
	} 
	
	// 2. 전자결재 생성 요청 
	public String createWFDocumentXML(HashMap apprMap) throws Exception {
		String returnData = "";
		try {
            String xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    				+"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    				+"<soap:Body>"  				
					+"<CreateDocument xmlns=\"http://tempuri.org/WfWebService/CreateDoc\">"
					+"<pid><![CDATA["+StringUtil.checkNull(apprMap.get("pid"))+"]]></pid>"
					+"<creatorID><![CDATA["+StringUtil.checkNull(apprMap.get("approverID"))+"]]></creatorID>"
					+"<chargerID></chargerID>"
					+"<isSave>true</isSave>"
					+"</CreateDocument>"
					+"</soap:Body>"
					
					+"</soap:Envelope>";
			 
			byte[] str = xml.getBytes("utf-8");

			returnData = new String(str,"utf-8");
				        
		} catch (Exception e) {
			e.printStackTrace();
		}    
		return returnData;
	} 
		
	
	public ModelMap zDlm_getApprovalMailForm(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		List attachFileList = new ArrayList();
		List wfInstList = new ArrayList();
		List wfRefInstList = new ArrayList();
		try {
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID")); // activityLogID
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
				String actorID = StringUtil.checkNull(commandMap.get("actorID"));
				String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
				String inhouse = StringUtil.checkNull(commandMap.get("inhouse"));
				
				model.put("wfDocType",wfDocType);		
				
				setMap.put("WFStepIDs", "'AREQ','APRV'");
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
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", projectID);
				Map getPJTMap = new HashMap();

				setMap.put("itemID", projectID);
				setMap.put("DocCategory", wfInstInfo.get("DocCategory"));
				setMap.put("DocumentID", commandMap.get("documentID"));
				
				
				Map getSRInfoMap = new HashMap();
				setMap.put("srCode", StringUtil.checkNull(commandMap.get("documentNo")));
				String srID = commonService.selectString("esm_SQL.getSRID", setMap);
				setMap.put("srID", srID);
					
				getSRInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);	
				String srDescription = StringUtil.replaceFilterString(StringUtil.checkNull(getSRInfoMap.get("Description")));
				getSRInfoMap.put("Description", srDescription);
				attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
				model.put("getSRInfoMap", getSRInfoMap);
				
				setMap.put("category", "DOCCAT");
				setMap.put("typeCode", wfInstInfo.get("DocCategory"));
				
				getPJTMap.put("WFDocType",StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap)));
				
				Description = StringUtil.checkNull(getPJTMap.get("Description"),"");
				Description = StringUtil.replaceFilterString(Description);
				getPJTMap.put("Description", Description);	
				model.put("getPJTMap", getPJTMap);				
				
				setMap.put("WFStepIDs", "'AREQ','APRV'");
				setMap.put("WFStepID", "");
				
				if(inhouse.equals("Y")) {
					String wfPath = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFPath", setMap));
					if(!wfPath.equals(""))
					wfInstList = getWFPathList(wfPath);
				}else {
					wfInstList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);
				}
				

				String wfURL = commonService.selectString("wf_SQL.getWFCategoryURL", setMap);	
				
				setMap.put("emailCode", commandMap.get("emailCode") );
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
				
				// 진행이력 정보 				
				setMap.put("activityLogID", commandMap.get("documentID"));
				Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setMap);
				model.put("activityLogInfo", activityLogInfo);
				
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
				model.put("inhouse", inhouse);
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return model;
	}
	
	public String createWfApprXML(HashMap apprMap) throws Exception {
		String returnData = "";
		try {
            String xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    				+"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    				+"<soap:Body>"
					+"<CreateDocument xmlns=\"http://tempuri.org/WfWebService/CreateDoc\">"
					+"<pid>"+apprMap.get("pid") +"</pid>"
					+"<creatorID>"+apprMap.get("approveId")+"</creatorID>"
					+"<chargerID></chargerID>"
					+"<isSave>true</isSave>"
					+"</CreateDocument>"
					+"</soap:Body>"
					+"</soap:Envelope>";
			 
			byte[] str = xml.getBytes("utf-8");

			returnData = new String(str,"utf-8");
				        
		} catch (Exception e) {
			e.printStackTrace();
		}    
		return returnData;
	} 
	
	public String readDocumentWfXML(InputStream stream, String returnParam) throws Exception {
		String returnString = "";
		try {
			Document  doc =   parseXML(stream);
			System.out.println("readDocumentWfXML return stream :"+doc);
			
            // SetLegacyInstanceResult 안에 XML 문이 들어 있음
            NodeList nl = doc.getElementsByTagName("SetLegacyInstanceResult");
            Node node = nl.item(0).getFirstChild();
            String nodeStr = node.getNodeValue();            
            
            System.out.println("SetLegacyInstanceResult content: " + nodeStr);            
            
            InputStream is2 = new ByteArrayInputStream(nodeStr.getBytes());            
            // SetLegacyInstanceResult 안의 XML 문을 다시 파싱
            Document  responseDoc = parseXML(is2);
            
            NodeList nl2 = responseDoc.getElementsByTagName(returnParam); // PID, ReturnCode
            responseDoc.getElementsByTagName("");  
            
            node =  nl2.item(0).getFirstChild();
            
            //결과 확인 처리
            if (node.getNodeValue() == null){
            	nl2 = responseDoc.getElementsByTagName("ReturnMessgae");
            	node = nl2.item(0).getFirstChild();
            	new Exception(node.getNodeValue());
            }
            
            returnString = node.getNodeValue();
            System.out.println("returnString :"+returnString);
            is2.close();
				        
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
			System.out.println(e.getMessage());
		}    
		return returnString;
	} 
	
	public HashMap readDocumentWfXMLV2(InputStream stream) throws Exception {
		HashMap resultMap = new HashMap();
		try {
			Document  doc =   parseXML(stream);
			
			// 전체 XML 문자열로 변환 //  returnString = convertDocumentToString(doc); System.out.println("전체 XML: " + returnString);
			/*
			<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<soap:Body><CreateDocumentResponse xmlns="http://tempuri.org/WfWebService/CreateDoc">
			<CreateDocumentResult>&lt;WF&gt;&lt;RTN&gt;ERROR&lt;/RTN&gt;&lt;ERROR_MSG&gt;연동 데이타가 없습니다.&lt;/ERROR_MSG&gt;&lt;/WF&gt;</CreateDocumentResult>
			</CreateDocumentResponse></soap:Body></soap:Envelope>
			------------------------------------------------------------------------------------------------------------------
			 node.getNodeValue() :<WF><RTN>ERROR</RTN><ERROR_MSG>연동 데이타가 없습니다.</ERROR_MSG></WF>
            */
			NodeList nl = doc.getElementsByTagName("CreateDocumentResult");
            Node node = nl.item(0).getFirstChild();
            String nodeStr = node.getNodeValue();
            System.out.println("newApproveSoapService 결과  : "+nodeStr);
            
            // 문자열을 InputStream으로 변환
            InputStream stream2 = new ByteArrayInputStream(nodeStr.getBytes(StandardCharsets.UTF_8));
            
            // XML 문서 파서 준비
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc2 = builder.parse(stream2);
            
            // <WF> 요소 가져오기
            NodeList wfList = doc2.getElementsByTagName("WF");
            if (wfList.getLength() > 0) {
                Element wfElement = (Element) wfList.item(0);

                // <RTN>와 <ERROR_MSG> 값 추출
                String rtnValue = getNodeValue(wfElement, "RTN");
                String errorMsgValue = getNodeValue(wfElement, "ERROR_MSG");
                
                resultMap.put("RTN", StringUtil.checkNull(rtnValue));
                resultMap.put("ERROR_MSG", errorMsgValue);
                // 결과 출력
                System.out.println("RTN: " + rtnValue);
                System.out.println("ERROR_MSG: " + errorMsgValue);
            } else {
                System.out.println("WF 노드가 없습니다.");
            }

		} catch (Exception e) {
			e.printStackTrace();
		}    
		return resultMap;
	} 
	
	// 노드 값을 가져오는 메서드 
    private static String getNodeValue(Element parentElement, String tagName) {
        NodeList nodeList = parentElement.getElementsByTagName(tagName);
        if (nodeList.getLength() > 0) {
            Node node = nodeList.item(0);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                // 자식 노드 탐색하여 텍스트 값 가져오기
                StringBuilder textValue = new StringBuilder();
                NodeList childNodes = node.getChildNodes();
                for (int i = 0; i < childNodes.getLength(); i++) {
                    Node child = childNodes.item(i);
                    if (child.getNodeType() == Node.TEXT_NODE) {
                    	
                    	System.out.println("child.getNodeValue() :"+child.getNodeValue());
                        textValue.append(child.getNodeValue());
                    }
                }
                return textValue.toString(); // 텍스트 값 반환
            }
        }
        return null; // 값이 없을 경우 null 반환
    }
    
	public Document parseXML(InputStream stream) throws Exception {
		DocumentBuilderFactory objDocumentBuilderFactory = null;
	    DocumentBuilder objDocumentBuilder = null;
	    Document doc = null;

	    try{

	        objDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
	        objDocumentBuilder = objDocumentBuilderFactory.newDocumentBuilder();

	        doc = objDocumentBuilder.parse(stream);
	        System.out.println("parseXML doc :"+doc);

	    }catch(Exception e){
	    	
			throw e;
	    }       

	    return doc;
	} 
	
    public static boolean zdlm_sendPush(HashMap vo, CommonService commonService) throws Exception {
		
		boolean isSendSuccess = false;
		
		//PushServer URL
		String url = DaelimGlobalVal.DLM_PUSH_serverUrl;
		HttpEntity<MultiValueMap<String, String>> httpRequest = makeHttpRequest(vo);
		
		// log 저장
		String maxId = StringUtil.checkNull(commonService.selectString("email_SQL.emailLog_nextVal", vo)).trim();
		vo.put("EmailCode", vo.get("EmailCode"));
		vo.put("docCategory", "PUSH");
		vo.put("Receiver", vo.get("RecvInfo"));
		vo.put("Sender", DaelimGlobalVal.DLM_PUSH_senderName);
		vo.put("SEQ", maxId);
		commonService.insert("email_SQL.insertEmailLog", vo);
		
		byte[] result = null;
		result = new RestTemplate().postForObject(url, httpRequest, byte[].class);
		String responseJson = new String(result, "UTF-8");
		
		System.out.println("responseJson : "+ responseJson);
		// responseJson 값  : {"BODY":{"PUSH_SEND_CNT":0}}
		
		JSONObject jObj = new JSONObject(responseJson);
		JSONObject bodyJsonObject = jObj.getJSONObject("BODY");
		HashMap<String, Object> bodyMap = new HashMap<>();
		Iterator<String> keys = bodyJsonObject.keys();
		while (keys.hasNext()) {
		    String key = keys.next();
		    bodyMap.put(key, bodyJsonObject.get(key));
		}
		// HashMap<String, Object> bodyMap =  (HashMap<String, Object>) jObj.get("BODY"); // *  JSON Cannot be cast to java.base/java.util.HashMap
		
		int pushSendCount = (Integer) bodyMap.get("PUSH_SEND_CNT");
		if(pushSendCount > 0) {
			isSendSuccess = true;
			System.out.println("pushSendCount : "+ pushSendCount);
		} 
	
		return isSendSuccess;
		
	}
	
	private static HttpEntity<MultiValueMap<String, String>> makeHttpRequest(HashMap vo) {
		
		LinkedMultiValueMap<String, String> param = new LinkedMultiValueMap<String, String>();
		
		//MediaType
		MediaType mediaType = new MediaType("application","x-www-form-urlencoded", Charset.forName("UTF-8"));
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(mediaType);
		
		String serviceCode = DaelimGlobalVal.DLM_PUSH_serviceCode;
		String appId = DaelimGlobalVal.DLM_PUSH_appId;
		String senderCode = DaelimGlobalVal.DLM_PUSH_senderCode;
		String senderName = DaelimGlobalVal.DLM_PUSH_senderName;
		String senderNum = DaelimGlobalVal.DLM_PUSH_senderNum;
		String sendSMS_YN = DaelimGlobalVal.DLM_PUSH_sendsmsYn;
		String usrId = StringUtil.checkNull(vo.get("RecvEmpNo")); // 수신자 ID
		String phoneNo = StringUtil.checkNull(vo.get("RecvInfo")); // 수신자 전화번호
		String recvEmpName = StringUtil.checkNull(vo.get("RecvEmpName")); // 수신자 이름
		String recvDeptName = StringUtil.checkNull(vo.get("RecvDeptName")); // 수신자 부서이름
		String companyCode = StringUtil.checkNull(vo.get("CompanyCode"));
		String emailCode = StringUtil.checkNull(vo.get("EmailCode"));
		String srCode = StringUtil.checkNull(vo.get("srCode"));
		String subject = StringUtil.checkNull(vo.get("subject"));
		String title = "";
		String desc = "";
		String message = ""; // 발송 메시지
		
		
		if("ESPMAIL001".equals(emailCode) || "ESPMAIL002".equals(emailCode)){
			// ASSIGN
			title = "eClick 업무 알림";
			desc += "아래의 업무가 할당되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}
		else if("ESPMAIL003".equals(emailCode)){
			// SL_RECEIPT
			title = "eClick 티켓이 IT담당자에게 접수되었습니다.";
			desc += "아래의 업무가 IT담당자에게 접수되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}
		else if("ESPMAIL004".equals(emailCode)){
			// DENIED
			title = "eClick 반려 알림";
			desc += "아래의 업무가 반려되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}else if("ESPMAIL005".equals(emailCode)){
			// REJECTION
			title = "eClick 기각 알림";
			desc += "아래의 업무가 기각되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}else if("ESPMAIL006".equals(emailCode)){
			// CUSTOMER_APPROVE
			title = "eClick 결재요청 알림";
			desc += "아래의 업무에 대한 결재가 요청되었습니다.";
			desc += "그룹웨어의 임시보관함 확인을 부탁 드립니다.";
		}else if("ESPMAIL007".equals(emailCode)){
			// APPROVAL_DENIED
			title = "eClick 결재반려 알림";
			desc += "아래의 업무에 대한 결재가 반려되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}else if("ESPMAIL008".equals(emailCode)){
			// SATISFACTION_SURVEY
			title = "eClick 만족도조사 알림";
			desc += "아래의 업무에 대하여 만족도조사에 응답해주시기 바랍니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}else if("ESPMAIL009".equals(emailCode)){
			// USER_TEST_ASSIGN
			title = "eClick 업무 알림";
			desc += "아래의 업무가 할당되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}
		else if("ESPMAIL010".equals(emailCode)){
			// 프로세스 종료 알림
			title = "eClick 프로세스 처리완료 알림";
			desc += "아래의 요청하신 업무처리가 완료되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}else if("ESPMAIL011".equals(emailCode)){
			title = "eClick 티켓완료 지연 및 완료예정 안내";
			desc += "아래의 업무에 대하여 지연 티켓이 자동 완료되었습니다.";
			desc += "자세한 사항은 eClick에 접속하여 업무 확인 부탁 드립니다.";
		}
		message = "[" + title + "] [" + srCode + "]" +  subject + " " + desc;
		
		//Parameter
		param.add("CUID",  "[\"" + usrId + "\"]");
		param.add("RECIPIENT_NUM", "[\"" + phoneNo + "\"]");
		param.add("RECIPIENT_NM", "[\"" + recvEmpName + "\"]");
		param.add("RECIPIENT_DEPT", "[\"" + recvDeptName + "\"]");
		param.add("MESSAGE", message); 
		param.add("PRIORITY", "3");
		param.add("BADGENO", "0"); 
		param.add("RESERVEDATE", "");
		param.add("SERVICECODE", serviceCode);
		param.add("SOUNDFILE", "");
		param.add("APP_ID", appId);
		param.add("SENDERCODE", senderCode);
		param.add("SENDER_NM", senderName);
		param.add("SENDER_NUM", senderNum);
		param.add("SENDER_DEPT", "");
		param.add("PUSH_FAIL_SMS_SEND", sendSMS_YN);
		param.add("DB_IN", "Y");
		param.add("COMP", companyCode);
		param.add("MDM_USEING_YN", "[\"N\"]");
		
		
		System.out.println("PushServer Info -> " + serviceCode + "/" + appId + "/" + senderCode + "/" + senderName + "/" + senderNum + "/" + sendSMS_YN);
		//System.out.println("Message Info -> [UsrId : {}, RecvEmpName : {}, RecvDeptName : {}, PhoneNo : {}, CompanyCode : {}, Message : {}", usrId, recvEmpName, recvDeptName, phoneNo, companyCode, message);
		
	
		
		return new HttpEntity<MultiValueMap<String, String>>(param, headers);
		
	}
	

	@RequestMapping({"/zdlm_ChangeFileFolder.do"})
    public String zdlm_ChangeFileFolder(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { 

		HashMap tmpMap = new HashMap();
    	List<HashMap> fileList = commonService.selectList("zDaelim_SQL.zDaelim_SelectAllFileList", tmpMap);
    	
    	
    	for(HashMap fMap : fileList) {
    		String fileName = StringUtil.checkNull(fMap.get("FileName"));
    		String filePath = StringUtil.checkNull(fMap.get("FilePath"));
    		String orgPath = "C:/eClick/upload/" + fileName.substring(0, 4) + '/' + fileName.substring(5, 6) + '/' + fileName;
    		String newPath = filePath + fileName;
			
			File orgFile = new File(orgPath);
			File newFile = new File(newPath);
			
			 
			try {
				orgFile.renameTo(newFile);
			}
			catch (Exception e) {
			   e.printStackTrace();
		    	System.out.println("test error");
			}

    	}
    	
	    return nextUrl(AJAXPAGE); 
	}	
	
	/*
	 * 전자결재 흐름 : 결재 eclick 에서 pid 요청하여 받아지면-> eclick 에서 생성요청 -> 전자결재에서 생성후 eclick의
	 * /custom/zDlm_AprvProcessing.do 호출후 정상적으로 수행하여 ReturnCode :S 를 받으면 정상 처리 되었다고
	 * eclick 에 리턴해줌
	 */
	// http://localhost//custom/zDlm_AprvProcessing.do?PID=15F9978749D34C8E91A34E3282637DA0&ApproveYN=Y&ApproveId=
	@RequestMapping({"/custom/zDlm_AprvProcessing.do"})	
	public void zDlm_updateRetrunAprvProcessing(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception { 
		System.out.println("/custom/zDlm_AprvProcessing.do ::::::: come come ");	
		String url = "";
    	Map target = new HashMap();
    	Map setData = new HashMap();
    	
    	Map<String, String> responseMap = new HashMap<>();
		String resMsg  = "S";
		responseMap.put("ReturnCode", resMsg); // resMsg 값 그대로 추가

        // ObjectMapper를 사용하여 Map을 JSON으로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonResponse = objectMapper.writeValueAsString(responseMap);
        
        response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("text/plain");
	    response.setCharacterEncoding("UTF-8");
        // JSON 응답을 반환
    	try {
    			// 파라미터 전달 받은 방식
    		 	String method = request.getMethod(); 
	    		 // 요청 파라미터 이름 가져오기
	            Enumeration<String> parameterNames = request.getParameterNames();
	            
	            // 파라미터 이름을 하나씩 확인하며 출력
	            while (parameterNames.hasMoreElements()) {
	                String paramName = parameterNames.nextElement();
	                String paramValue = request.getParameter(paramName);
	                
	                // 파라미터 이름과 값을 출력
	                System.out.println( paramName + ": " + paramValue );
	            }
	            
	            String pid = StringUtil.checkNull(request.getParameter("PID"));
    			String approveYN = StringUtil.checkNull(request.getParameter("ApproveYN"));   //  (P:결재중(APP000102) Y:승인(APP000103) N:반려(APP000104))
    			String approveId = request.getParameter("ApproveId"); // ApproveId : 요청자 loginID 
    			String lastApvId = request.getParameter("lastApvId"); 
    			String apvlist = "";
    			
    			String apvlistOrg = StringUtil.checkNull(request.getParameter("apvlist"));
    			System.out.println("/custom/zDlm_AprvProcessing.do ==> Start ::: PID =>"+pid+", approveId:"+approveId+",   apvlistOrg:"+apvlistOrg);   
    			
    			if(!apvlistOrg.equals("")) {
    				String queryString =request.getQueryString(); // 예: "PID=C0A53017DE6D4ABB80E81C2E73B98D51&ApproveYN=Y&ApproveId=SAM20131026&apvlist=<steps...>"
    				
    				System.out.println("queryString:"+queryString); 
    				if (queryString != null  && !queryString.equals("")) {
			     		// 쿼리 문자열에서 "apvlist=" 파라미터 값만 추출(apvlist 내용중 & 값이 있는게 있어서 그부분에서 파라미터가 짤리는 문제로 인해 apvlist 값추출로직 구현
		     			Pattern apvlistPattern = Pattern.compile("apvlist=(.+)$");// apvlist=로 시작하고 그 뒤에 오는 값을 추출($는 문자열 끝까지 매칭 & 상관없이)
			     		Matcher matcher = apvlistPattern.matcher(queryString);
			     		
			     		// "apvlist" 파라미터 값을 찾고 저장
			     		if (matcher.find()) {
			     			apvlist = matcher.group(1);  // "apvlist=" 다음의 값 추출
			     			apvlist = URLDecoder.decode(apvlist, "UTF-8"); // URL 디코딩 처리 ( &lt; 식으로 된 entity 문자를 < 이렇게 변환 xml 파싱하려면 )
			     		   // apvlistValue = apvlistValue.replaceAll("&amp;", "&"); // HTML 엔티티 처리 (필요한 경우 추가적으로 처리)
			     		} else {
			     		    apvlist = "";
			     		}
    				}
    			}
    			
    			System.out.println("approveYN :"+approveYN+",approveId :"+approveId+",PID :"+pid+",apvlist :"+apvlist);
    			
    			List wfStepResultList = new ArrayList();
    			if(!apvlist.equals("") && !apvlistOrg.equals("")) {
    			
	    			// XML 파서 준비
	  	          	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	  	          	DocumentBuilder builder = factory.newDocumentBuilder();
	  	          	InputStream is = new ByteArrayInputStream(apvlist.getBytes("UTF-8"));
	  	          	Document document = builder.parse(is);
	  	          	document.getDocumentElement().normalize();
	
	  	          	// 예시: 'steps' 엘리먼트의 'datecreated' 속성 추출
	  	          	String dateCreated = document.getDocumentElement().getAttribute("datecreated");
	  	          	System.out.println("Date Created: " + dateCreated);
	  	          	
	  	          	HashMap wfStepInfo = new HashMap();
	  	          	// 예시: 모든 'person' 엘리먼트에서 이름 추출
	  	          	NodeList personList = document.getElementsByTagName("person");
	  	          	for (int i = 0; i < personList.getLength(); i++) {
	  	              Element person = (Element) personList.item(i);
	  	              String personName = person.getAttribute("name");
	  	              String code = person.getAttribute("code");  	
	  	              wfStepInfo = new HashMap();
	  	              
	  	              wfStepInfo.put("stepName", personName);
	  	              wfStepInfo.put("empNo", code);
	  	            
	                  // <taskinfo>에서 status 추출
	  	              /*
	  	               * completed : 승인 (@result="authorized" 경우 전결)  rejected : 반려  pending : 대기 
	  	               * inactive : 예정 (@kind="review" 경우 후결)  skipped : 결재안함 (전결 등으로 인한)
					 */
	
	                  NodeList taskInfoList = person.getElementsByTagName("taskinfo");
	                  for (int k = 0; k < taskInfoList.getLength(); k++) {
	                      Element taskInfoElement = (Element) taskInfoList.item(k);
	                      String status = taskInfoElement.getAttribute("status");
	                      String result = taskInfoElement.getAttribute("result"); // result="authorized" 경우 전결
	                      String kind = taskInfoElement.getAttribute("kind"); // kind="review" 경우 후결
	                      String datecompleted = taskInfoElement.getAttribute("datecompleted"); // 승인일
	                      System.out.println("Person: " + personName + ", code: " + code + ", Task Status: " + status +", datecompleted:"+datecompleted);
	                      
	                      wfStepInfo.put("result", result);
	                      wfStepInfo.put("status", status);
	                      wfStepInfo.put("aproveDate", datecompleted);
	                      wfStepInfo.put("kind", kind);
	                      
	                      // <taskinfo>에서 status 추출
	                      NodeList commentInfo = taskInfoElement.getElementsByTagName("comment");
	                      for (int j = 0; j < commentInfo.getLength(); j++) {
	                          Element commentElement = (Element) commentInfo.item(j);
	                          String comment = commentElement.getFirstChild().getNodeValue();
	                          System.out.println("comment: " + comment );
	                          wfStepInfo.put("comment", comment);
	                      }
	                  }
	                  wfStepResultList.add(wfStepInfo); // 특수문자 치환
	  	          	}
	  	          	
	  	          	
	  	          	System.out.println("wfStepResultList : "+wfStepResultList);
    			}
    			
  	          	//========================================================================================================================================
  	            // 파람정보  => PID=" + PID + "&ApproveYN=" + apvYN + "&ApproveId=" + lastApvId + "&apvlist=" + sAPVL

    			setData.put("returnValue", pid);
    			Map wfInstanceInfo = commonService.select("wf_SQL.getWFINSTanceInfo", setData);
    			
    			String wfInstanceID = StringUtil.checkNull(wfInstanceInfo.get("WFInstanceID"));
    			String srCode = StringUtil.checkNull(wfInstanceInfo.get("DocumentNo"));
    		    setData.put("srCode", srCode);			
    			String srID = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRID", setData));
    			String activityLogID = StringUtil.checkNull(wfInstanceInfo.get("DocumentID"));
    			
    			setData.put("srID", srID);
    			setData.put("languageID", "1042");
    			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData); 
    			    			
    			setData.put("wfID", StringUtil.checkNull(wfInstanceInfo.get("WFID")));
    			setData.put("wfDocType", StringUtil.checkNull(wfInstanceInfo.get("DocCategory")));
    			// setData.put("docSubClass", StringUtil.checkNull(srInfo.get("Status")));
    			setData.put("activityLogID", activityLogID);
    			
    			setData.put("wfInstanceID", wfInstanceID);
    			String speCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getActivitySpeCode", setData));
    			setData.put("docSubClass",speCode);
    			String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setData));
    			
    		    String status = "";
    		    if(approveYN.equals("T")) { // 임시저장
    		    	status = "0"; // 편집중
    		    } else if(approveYN.equals("Y")) { // 최종결재 
    				status = "2"; // 완료(승인)
    			} else if(approveYN.equals("R")){ // 반려
    				status = "3"; // 반려(반송)
    			} else if(approveYN.equals("P")) { // 결재진행중(상신,중간승인)
    				status = "1"; // 상신 
    			} else if(approveYN.equals("D")){ // 삭제     				
    				System.out.println("삭제 approveYN :::"+approveYN);
    				
    				status = "-1";    				
    				
    				// 삭제 시 재상신으로 로그상태 변경
    				setData.put("PID", srID);
    				setData.put("activityStatus", "10"); // 재상신
    				setData.put("activityLogID", activityLogID);
					Map setActivityLogMapRst = (Map)ESPUtil.updateActivityLog(request, commonService, setData);
    				
    			} else if(approveYN.equals("NA")){ // 예외(오류는 아니지만 예외)
    				System.out.println("NA approveYN :::"+approveYN);    				
    			}
    		    
    		    //결재선 정보 
    		    String empCode = "";
    		    if (!wfStepResultList.isEmpty()) {
    		        // 마지막 로우의 HashMap을 가져옴
    		        HashMap lastStepInfo = (HashMap) wfStepResultList.get(wfStepResultList.size() - 1);
    		        
    		        empCode = (String) lastStepInfo.get("empNo");    		        	
    		    }
    		    if(empCode.equals("")) { empCode = approveId;}
    		    setData.put("loginID", empCode);    		    
    		    String lastSigner = StringUtil.checkNull(commonService.selectString("user_SQL.member_id_select", setData));
    			setData.put("Status", status);
    			setData.put("WFInstanceID", wfInstanceID);
    			
    			setData.put("LastUser",  lastSigner);
    			setData.put("LastSigner", lastSigner); 
    			setData.put("ActorID", lastSigner); 
    			setData.put("Path", apvlistOrg); //확인하기 
    			
    			// update wf_inst 
    			commonService.update("wf_SQL.updateWfInst", setData);
    			commonService.update("wf_SQL.updateWFStepInst", setData);
    			
    			
    			
    			// ****  
    			// 결재가 중복 생성일경우 먼저 생성된 결재가 승인/반려 (최종결재)되었을 경우 후처리 로직 타지 않도록 
    			// ESM_ACTIVITY_LOG.WFInstanceID 에 없는 wfInstanceID 일경우 후처리 로직 타지 않도록  select status from XBOLTAPP.ESM_ACTIVITY_LOG Where WFInstaneID = 
    			
    			
    			if(StringUtil.checkNull(wfInstanceInfo.get("Comment")).equals("asisEclick")) { // asis 전자결재 후처리 
    				setData.put("PID", srID);
    				setData.put("activityLogID", activityLogID);
    				setData.put("SpeCode", speCode);
    				if(approveYN.equals("Y")) {
	    				setData.put("Status", "03");
	    				    				
	    				commonService.update("esm_SQL.updateActivityLog", setData);
    				}
    				setData.put("srID", srID);
    				setData.put("status", StringUtil.checkNull(commonService.selectString("esm_SQL.getLastActivityLogIDSpeCode", setData)));    				
    				commonService.update("esm_SQL.updateESMSR", setData); // 제일 마지막 activity log speCode sr.status  update
    				
    				System.out.println("responseMap returnCode :"+responseMap);
    				
    			} else {
	    			if(!postProcessing.equals("")) { // /custom/srAprvProcessing.do
	    				// session 정보 강제 생성( 메일보낼때 xboltController쪽에서 session에 loginInfo 정보사용해야 해서 )
	    				HttpSession session = request.getSession(true);
	    				Map loginInfo = (Map)session.getAttribute("loginInfo");
	    				if (loginInfo == null) {
	    				    loginInfo = new HashMap(); // 새 Map 생성
	    				    session.setAttribute("loginInfo", loginInfo); // 세션에 다시 등록
	    				}

	    				// 값 주입
	    				loginInfo.put("sessionUserId", StringUtil.checkNull(wfInstanceInfo.get("Creator")));      
	    				loginInfo.put("sessionCurrLangType", "1042");           
	    				
	    				System.out.println("sessionUserId :"+(String) loginInfo.get("sessionUserId"));
	    				System.out.println("sessionCurLangType : "+(String) loginInfo.get("sessionCurrLangType"));
	    				
	    				String data = "curWFInstanceID="+wfInstanceID+"&srID="+srID+"&roleType="+StringUtil.checkNull(srInfo.get("ProcRoleTP"))
	    							+ "&languageID=1042&lastUser="+StringUtil.checkNull(wfInstanceInfo.get("Creator"))+"&activityLogID="+activityLogID
	    							+ "&sessionUserId="+StringUtil.checkNull(wfInstanceInfo.get("Creator"))+"&pid="+pid+"&approveYN="+approveYN;
	    				postProcessing += "?" + data;
	    				System.out.println("postProcessing :"+postProcessing);
	    				
	    				response.sendRedirect(postProcessing);
	    			}
    			}
    	}catch (Exception e){	    
    		
	    	resMsg = "S";// xml 값 그대로 추가
	    	responseMap = new HashMap<>();
	        responseMap.put("ReturnCode", resMsg); // resMsg 값 그대로 추가
	       
	    	System.out.println("/custom/zDlm_AprvProcessing.do ERROR :"+ e);	
	    	response.getWriter().print(objectMapper.writeValueAsString(responseMap));
	    }
	    
	    response.getWriter().print(jsonResponse);
	} 
	
	//xml validation check
    private boolean isValidXML(String xmlData) {
        try {
            // Try to parse the XML to see if it's well-formed
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            InputStream is = new ByteArrayInputStream(xmlData.getBytes("UTF-8"));
            builder.parse(is);
            System.out.println("XML Validation Success ");
            return true; // If no exception occurs, XML is valid
        } catch (Exception e) {
        	System.out.println("XML Validation Error: " + e.getMessage());
            return false; // Invalid XML
        }
    }
    
    public static String extractFirstPart(String input) {
        if (input == null || input.trim().isEmpty()) {
            return ""; // null 또는 공백일 경우 빈 문자열 반환
        }

        // 세미콜론 기준으로 split
        String[] parts = input.split(";");
        return parts.length > 0 ? parts[0].trim() : "";
    }
	
	public List getWFPathList(String wfPath) throws Exception {
		List wfPathList = new ArrayList();
		HashMap<String, String> wfStepInfo = new HashMap<>();
	    try{
	    	System.out.println("StringEscapeUtils.unescapeHtml4(wfPath) :"+StringEscapeUtils.unescapeHtml4(wfPath));
	    	if (!isValidXML(StringEscapeUtils.unescapeHtml4(wfPath))) { // xml validation check
	    		System.out.println("🚫 유효하지 않은 XML입니다.");
	    		 return wfPathList;
	        }
	    	 
	    	// XML 파서 준비
	    	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    	DocumentBuilder builder = factory.newDocumentBuilder();
	    	InputStream is = new ByteArrayInputStream(StringEscapeUtils.unescapeHtml4(wfPath).getBytes("UTF-8"));
	    	Document document = builder.parse(is);
	    	document.getDocumentElement().normalize();

	    	// 예시: 'steps' 엘리먼트의 'datecreated' 속성 추출
	    	String dateCreated = document.getDocumentElement().getAttribute("datecreated");
	    	System.out.println("Date Created: " + dateCreated);

	    	// <steps> 내의 모든 <step> 태그를 순회
	    	NodeList steps = document.getElementsByTagName("step");

	    	System.out.println("steps.getLength();"+steps.getLength());

	    	for (int a = 0; a < steps.getLength(); a++) {
	    	    Node stepNode = steps.item(a);
	    	    wfStepInfo = new HashMap();
	    	    if (stepNode.getNodeType() == Node.ELEMENT_NODE) {
	    	        Element stepElement = (Element) stepNode;

	    	        // routetype 속성 추출
	    	        String routeType = stepElement.getAttribute("routetype");

	    	        // 각 step에 대한 정보를 담을 HashMap 생성
	    	        
	    	        wfStepInfo.put("WFStepName", routeType); // step의 routeType을 추가

	    	        // 'person' 요소 순회하여 해당 정보를 wfStepInfo에 담기
	    	        NodeList personList = stepElement.getElementsByTagName("person");
	    	        for (int i = 0; i < personList.getLength(); i++) {
	    	            Element personElement = (Element) personList.item(i);
	    	            
	    	            String personName = personElement.getAttribute("name");
	    	            String code = personElement.getAttribute("code");    
	    	            String ouname = extractFirstPart(personElement.getAttribute("ouname"));
	    	            
	    	            String[] personNameParts=null;
	    	            if(!personName.equals("")) {
	    	            	personNameParts = personName.split(";");
	    	            }

	    	            // person 정보 추가
	    	            wfStepInfo.put("ActorName", StringUtil.checkNull(personNameParts[0]));
	    	            wfStepInfo.put("empNo", code.replaceAll(";", ""));
	    	            wfStepInfo.put("TeamName", ouname.replaceAll(";", ""));

	    	            // 각 person에 대한 taskinfo 처리
	    	            NodeList taskInfoList = personElement.getElementsByTagName("taskinfo");
	    	            for (int k = 0; k < taskInfoList.getLength(); k++) {
	    	                Element taskInfoElement = (Element) taskInfoList.item(k);
	    	                String status = taskInfoElement.getAttribute("status");
	    	                String result = taskInfoElement.getAttribute("result");
	    	                String kind = taskInfoElement.getAttribute("kind");
	    	                String datecompleted = taskInfoElement.getAttribute("datecompleted");
	    	                String statusName = "";

	    	                // status에 따른 상태 이름 설정
	    	                if (kind.equals("charge") && status.equals("completed")) {
	    	                    statusName = "상신";
	    	                } else {
	    	                    switch (status) {
	    	                        case "completed": statusName = "승인"; break;
	    	                        case "rejected": statusName = "반려"; break;
	    	                        case "pending": statusName = "대기"; break;
	    	                        case "inactive": statusName = "예정"; break;
	    	                        case "skipped": statusName = "결재안함"; break;
	    	                    }
	    	                }

	    	                // taskinfo 정보를 wfStepInfo에 추가
	    	                wfStepInfo.put("result", result.replaceAll(";", ""));
	    	                wfStepInfo.put("status", status.replaceAll(";", ""));
	    	                wfStepInfo.put("StatusNM", statusName.replaceAll(";", ""));
	    	                wfStepInfo.put("ApprovalDate", datecompleted.replaceAll(";", ""));
	    	                wfStepInfo.put("kind", kind.replaceAll(";", ""));

	    	                // comment 정보 추출 및 wfStepInfo에 추가
	    	                NodeList commentInfoList = taskInfoElement.getElementsByTagName("comment");
	    	                for (int m = 0; m < commentInfoList.getLength(); m++) {
	    	                    Element commentElement = (Element) commentInfoList.item(m);
	    	                    String comment = commentElement.getFirstChild().getNodeValue();
	    	                    wfStepInfo.put("Comment", comment);
	    	                }
	    	            }
	    	        }

	    	        // 최종적으로 완성된 wfStepInfo를 wfPathList에 추가
	    	        System.out.println("wfStepInfo: " + wfStepInfo);
	    	        wfPathList.add(wfStepInfo);
	    	    }
	    	}

	    	

	    }catch(Exception e){
	    	
			throw e;
	    }       
	    return wfPathList;
	} 
	
	// http://localhost/custom/zDlm_InboundLink.do?olmLoginid=guest&object=file&linkID=39&linkType=fileID&languageID=1042
	@RequestMapping("/custom/zDlm_InboundLink.do")
	public String zDlmc_InboundLink(HttpServletRequest request, HttpServletResponse response, HashMap commandMap,
			ModelMap model) throws Exception {
		String url = "/template/olmLinkPopup";
		Map target = new HashMap();
		try {
/*
			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");

			String ssoEmp = "";
			String logonId = "";

			// 인증 시작
			WebAgent agent = new WebAgent(); // agent 호출
			agent.requestAuthentication(request, response);

			ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_PERSON_NO"));

			// ssoEmp 없으면 sso 로그인 페이지
			if (!"".equals(ssoEmp) && ssoEmp != null) {
				if (agent.requestAuthentication(request, response, false)) {
					// 인증처리 필요 (DL 그룹웨어로 이동)
					if (!response.isCommitted()) {
						url = "/index";
					}
				} else {
					// SSO 인증완료
					logonId = ssoEmp;

					Map setData = new HashMap();
					Map userInfo = new HashMap();
					setData.put("employeeNum","1");
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);

					if (userInfo != null && !userInfo.isEmpty()) {
						String activeYN = "N";
						HashMap setInfo = new HashMap();

						setInfo.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));

						activeYN = commonService.selectString("login_SQL.login_active_select", setInfo);
						if (!"Y".equals(activeYN)) {
							url = "/index";
						}

						model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
						model.put("loginid", StringUtil.checkNull(userInfo.get("LoginId")));
					}

					String languageID = StringUtil.checkNull(request.getParameter("languageID"));
					String object = StringUtil.checkNull(request.getParameter("object"), "");
					String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
					String linkType = StringUtil.checkNull(request.getParameter("linkType"), "");
					
					if(object.equals("")) object  ="file";
					if(linkType.equals("")) linkType  ="fileID";
					
					if (languageID.equals("")) {
						languageID = GlobalVal.DEFAULT_LANGUAGE;
					}

					model.put("languageID", languageID);
					model.put("keyId", StringUtil.checkNull(request.getParameter("keyId"), ""));
					model.put("object", object);
					model.put("linkType", linkType);
					model.put("linkID", linkID);
					model.put("iType", StringUtil.checkNull(request.getParameter("iType"), ""));
					model.put("aType", StringUtil.checkNull(request.getParameter("aType"), ""));
					model.put("option", StringUtil.checkNull(request.getParameter("option"), ""));
					model.put("type", StringUtil.checkNull(request.getParameter("type"), ""));
					model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"), ""));
					model.put("projectType", StringUtil.checkNull(request.getParameter("projectType"), ""));
					model.put("olmLng", StringUtil.checkNull(request.getParameter("olmLng"), ""));
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
					model.put("mainType", StringUtil.checkNull(request.getParameter("mainType"), ""));
					model.put("focusedObjID", StringUtil.checkNull(request.getParameter("focusedObjID"), ""));
				}
			} else {
				url = "/index";
			}
				
					*/
					
					Map setData =  new HashMap();
					String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
					setData.put("Seq", linkID);
					// Map fileMap = commonService.select("fileMgt_SQL.selectDownFile",setData);
					Map fileMap = commonService.select("zDLM_SQL.zdlm_selectDownFile",setData); // eClick AS-IS 퍄일일 경우 경로 조회 쿼리 하도록 변경 
					String filename = StringUtil.checkNull(fileMap.get("filename"));
					String original = StringUtil.checkNull(fileMap.get("original"));
					String downFile = StringUtil.checkNull(fileMap.get("downFile"));
					
					if (!new File(downFile).exists()) {					 
						 //target.put(AJAX_ALERT, "해당 파일 [ "+original+" ] 을 서버에서 찾을 수 없습니다");
						 target.put(AJAX_ALERT, MessageHandler.getMessage("KO.WM00078", new String[]{original}));						
						 model.addAttribute(AJAX_RESULTMAP, target);
						 return nextUrl(AJAXPAGE);
					}
					
					request.setAttribute("downFile", downFile);
					request.setAttribute("orginFile", original);
					
					FileUtil.flMgtdownFile(request, response);
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/zDlm_viewMyInfo.do")
	public String zDlm_viewMyInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
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
		return nextUrl("custom/daelim/itsm/user/zDlm_viewMyInfo");
	}
	
	@RequestMapping(value="/zDlm_deleteITODept.do")
	public String zDlm_deleteITODept(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();
			
			String ID_USER = StringUtil.checkNull(request.getParameter("ID_USER"));
			updateData.put("ID_USER",ID_USER);
			
			String CD_DEPT = "";
			String CD_DEPTs = StringUtil.checkNull(request.getParameter("CD_DEPT"));
			
			String Spl[] = CD_DEPTs.split(",");
			for (int i = 0; i < Spl.length; i++) {
				CD_DEPT = Spl[i];
				updateData.put("CD_DEPT", CD_DEPT);
				commonService.update("zDLM_SQL.deleteITODept", updateData);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/zDlm_saveITODept.do")
	public String zDlm_saveITODept(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();
			HashMap insertData = new HashMap();
			HashMap updateData = new HashMap();
			
			String companyID = StringUtil.checkNull(request.getParameter("companyID"));
			String deptID = StringUtil.checkNull(request.getParameter("deptID"));
			String venderID = StringUtil.checkNull(request.getParameter("venderID"));
			String DEPT_FLAG = StringUtil.checkNull(request.getParameter("deptFlag"));
			String YN_MANAGER = StringUtil.checkNull(request.getParameter("YN_MANAGER"));
			String memberID = StringUtil.checkNull(request.getParameter("memberID"));
			
			
			// cd_dept setting
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),""));
			setData.put("teamID",deptID);
			String CD_DEPT = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCode", setData));
			String NM_DEPT = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamName", setData));
			
			// vender setting
			setData.put("teamID",venderID);
			String BIZ_KEY = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCode", setData));
			
			setData.put("memberID", memberID);
			setData.put("CD_DEPT", CD_DEPT);
			String myDeptCNT = StringUtil.checkNull(commonService.selectString("zDLM_SQL.getMyITODeptCNT", setData));
			if(Integer.parseInt(myDeptCNT)>0) {
				updateData.put("memberID", memberID);
				updateData.put("CD_DEPT", CD_DEPT);
				updateData.put("YN_MANAGER", YN_MANAGER);
				updateData.put("BIZ_KEY", BIZ_KEY);
				commonService.update("zDLM_SQL.updateITODept", updateData);
			} else {
				// company
				setData.put("teamID", companyID);
				String CORP_ID = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCode", setData));
				String CORP_NAME = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamName", setData));
				
				insertData.put("memberID", memberID);
				insertData.put("CD_DEPT", CD_DEPT);
				insertData.put("NM_DEPT", NM_DEPT);
				insertData.put("CORP_ID", CORP_ID);
				insertData.put("CORP_NAME", CORP_NAME);
				insertData.put("DEPT_FLAG", DEPT_FLAG);
				insertData.put("YN_MANAGER", YN_MANAGER);
				insertData.put("BIZ_KEY", BIZ_KEY);
				commonService.insert("zDLM_SQL.insertITODept", insertData);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// create asis eclick wfInst
	@RequestMapping(value="/zDlm_createEclickWFInst.do")
	public String zDlm_createEclickWFInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
						
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl("custom/daelim/itsm/zDlm_createEclickWFInst");
	}
	
	// asis eclick 전자 결재 생성 
	@RequestMapping(value = "/zDlm_createEclickWFMgt.do")
	public String zDlm_createEclickWFMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/WebSite/Approval/Controls/WfWebService/CreateDoc.asmx?op=CreateDocument";
		
		//https://gw.daelimcloudtest.com/WebSite/Approval/Controls/WfWebService/CreateDoc.asmx?op=CreateDocument
		String actionType = "create";
		HashMap target = new HashMap();
		if(actionType.equals("create")) {
			
			// SR 요청자 
			String approverIDMemberID = StringUtil.checkNull(commandMap.get("srRequestUserID"));
			String category = StringUtil.checkNull(commandMap.get("category"));
			String subCategory = StringUtil.checkNull(commandMap.get("subCategory"));
		
			/*  ASIS 설명 
			 * 쿼리를 먼저 조회하고 2선처리자를 전자결재 생성자에 넣고 아래 쿼리를 조회해서 등록자가 존재하면 전자결재 생성자에 변경 
			 */
			// AP변경 의뢰유형이 오류인 경우 변경계획수립 단계의 전자결재는 요청자가 아닌 담당자한테 전자결재가 생성되야함
			// AP변경 + RCP300002(오류조치), ADD120102 인 경우
			
			if(!StringUtil.checkNull(commandMap.get("speCode")).equals("ACM0010")) { // 배포부서 승인이 아니면
				if("RCP020".equals(category) || "RCP030".equals(category)) { // 장애등록/신고,오류신고( REQ Cat)
					commandMap.put("speCode", "REQ0004"); // IT담당자 처리 pre actor 
					commandMap.put("preCategory", "'RCP020','RCP030','RDT120'"); // IT담당자 처리 pre actor 
					String preCatActor = StringUtil.checkNull(commonService.selectString("esm_SQL.getActorIDNoByPreCat",commandMap)); 
					if(!preCatActor.equals("")) {
						approverIDMemberID = preCatActor;
					}
				}
				//ADD100101 현업요청/오류조치 / RCP302 운영조치 RCP302003 오류조치
				if("RCP300002".equals(subCategory) || "ADD120102".equals(subCategory) || "ADD100101".equals(subCategory) || "RCP302003".equals(subCategory)){ // ACM 오류조치 
					approverIDMemberID =  StringUtil.checkNull(commandMap.get("actorID"));
				}
			} 
			
			if(StringUtil.checkNull(commandMap.get("speCode")).equals("ACM0010")) { // ACM 배포 부서 승인이면 : 담당자는 기존 이클릭 기준으로 해당 단계의 담당(접수)자
				approverIDMemberID =  StringUtil.checkNull(commandMap.get("actorID"));
			}
			
			commandMap.put("memberID",approverIDMemberID);
			Map requestUserInfo = commonService.select("user_SQL.getMemberInfo", commandMap);
			
			String approverID = "";
			String approverClientID = "";
			String approverTeamCode = "";
			if(!requestUserInfo.isEmpty()) {
				approverID = StringUtil.checkNull(requestUserInfo.get("LoginID"));
				approverClientID = StringUtil.checkNull(requestUserInfo.get("ClientID"));
				
				// * DLENC 는 사번으로 전달 
				if("0000000008".equals(approverClientID)){
					approverID = StringUtil.checkNull(requestUserInfo.get("EmployeeNum"));
				}
				
				approverTeamCode = StringUtil.checkNull(requestUserInfo.get("TeamCode"));
			}
			
			commandMap.put("approverID", approverID);
			commandMap.put("approverTeamCode", approverTeamCode);
			commandMap.put("asisEclick", "Y");
			
			String pid = zDlm_createWfDoc_GW(request, commandMap, model); // tb_wf_inst, tb_wf_step_inst 생성 및  GW pid 발급 요청
			
			if(!pid.equals("")) {
				
				// activity log 
				HashMap apprMap = new HashMap();
				apprMap.put("pid", pid);
				//apprMap.put("sessionUserID", "DCP30003150");	
				//approverID = "DCP30003150"; // 테스트 user(김현명) 적용시 필수 확인 
				apprMap.put("approverID", approverID);
				
				HashMap returnCreateDocDataMap = connGroupWareWF(apprMap,url,"createWFDocumentXML"); // S/F
				System.out.println("returnCreateDocDataMap :"+ returnCreateDocDataMap);
				
				if(!returnCreateDocDataMap.isEmpty()) {
					if(StringUtil.checkNull(returnCreateDocDataMap.get("RTN")).equals("ERROR")) {
						// target.put(AJAX_ALERT, StringUtil.checkNull(returnCreateDocDataMap.get("ERROR_MSG"))); // ERROR_MSG
						String ERROR_MSG = StringUtil.checkNull(returnCreateDocDataMap.get("ERROR_MSG"));						
						String DES = StringUtil.checkNull(returnCreateDocDataMap.get("DES"));
						
						String retrunMsg = DES;
						String extract_errMsg = extractBeforeDelimiter(ERROR_MSG, "/////");
						if(!extract_errMsg.equals("")) {
							retrunMsg = extract_errMsg;
						}
						
						target.put(AJAX_ALERT, retrunMsg); 
						//target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
						
					} else {
						target.put(AJAX_ALERT, "승인 요청이 완료 되었습니다."); // DES
						target.put(AJAX_SCRIPT, "fnReload();parent.$('#isSubmit').remove();");
					}
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				} else { // GW CreateDoc 요청 실패 
					target.put(AJAX_ALERT, "전자결재 생성 요청중 오류가 발생하였습니다."); 
					target.put(AJAX_SCRIPT, "fnReload();parent.$('#isSubmit').remove();");
				
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				}
				
			} else { // GW 연결 오류 
				target.put(AJAX_ALERT, "승인 요청 중 오류가 발생되었습니다."); 
				// target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
			
				model.addAttribute(AJAX_RESULTMAP, target);
				return nextUrl(AJAXPAGE);
				
			}
		} 
		
		return "resultView";
	}

}
