package xbolt.custom.ls.cmm;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.rathontech.sso.sp.agent.web.WebAgent;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.SessionConfig;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.custom.sk.cmm.ldap.LdapUserChecker;


@Controller
@SuppressWarnings("unchecked")
public class LSCmmActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;

	@RequestMapping(value = "/custom/ls/loginls.do")
	public String loginls(ModelMap model, HashMap cmmMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
				Map setMap = new HashMap();
				Map resultMap = new HashMap();
				
				SSOAuth auth = new SSOAuth(request, response);
				auth.processResponse();
				
				String id_Token = StringUtil.checkNull(request.getParameter("id_token"));
				
				Map<String, Object> attr = auth.getAttributes();
				
				
				if (!id_Token.equals("")) {
					if (attr.isEmpty()) { 			// 유저 값 없음 처리
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						resultMap.put(AJAX_ALERT, "User Information is not available. Please contact SSO Administrator.");
						auth.ssoLogin();
					} else { 						// 유저 값 있을 때
						
						Properties properties = new Properties();
						InputStream inputStream = getClass().getResourceAsStream("/config.properties");
						properties.load(inputStream);
						inputStream.close();					
						
						String aud = (String) attr.get("aud");
						String clientID = properties.getProperty("idp_client_id");
						
						if (aud.equals(clientID)) {
							String lsUPN = (String) attr.get("upn");
							
							setMap.put("email", lsUPN);
							
							String olmI = commonService.selectString("custom_SQL.zLSCNS_getUserLoginID", setMap);
							
							request.setAttribute("id_Token", id_Token);
							
							model.put("id_Token", id_Token);
							model.put("olmI", olmI);
							model.put("lsUPN", lsUPN);
							model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
							model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
							model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
							model.put("srType", StringUtil.checkNull(cmmMap.get("srType"), ""));
							model.put("esType", StringUtil.checkNull(cmmMap.get("esType"), ""));
							model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
							model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
							model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));
							
							return nextUrl("/indexLS");
						}
						
					}
					
				} else { // Token X
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					resultMap.put(AJAX_ALERT, "ID TOKEN is not exist. Please try logging in again.");
					auth.ssoLogin();
					
				}
			
				model.addAttribute(AJAX_RESULTMAP, resultMap);
				
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("LoginActionController::loginbase::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/custom/ls/loginPalLS.do")
	public String loginPalLS(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
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
						"Your ID does not exist in our system. Please contact system administrator(LSCNS).");
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
						// resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다. 등록 요청바랍니다.");
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

	
	@RequestMapping(value = "/custom/ls/loginlsForm.do")
	public String loginLSForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		model = setLoginScrnInfo(model, cmmMap);
		model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
		model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
		model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
		model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
		model.put("esType", StringUtil.checkNull(cmmMap.get("esType")));
		model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
		model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal")));
		model.put("status", StringUtil.checkNull(cmmMap.get("status")));
		
		return nextUrl("/custom/ls/login");
	}
	
	
	@RequestMapping(value = "/custom/ls/index.do")
	public String lsIndex(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		try{
			String ssoID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
			String lsSSO = StringUtil.checkNull(cmmMap.get("lsSSO"),"");
			
			model.put("olmI", ssoID);
			model.put("olmP", "");
			model.put("lsSSO", lsSSO);
			
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LSCmmActionController::mainpage::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/custom/ls/index");
	}	

	@RequestMapping(value = "/custom/ls/indexLS.do")
	public String goIndexLS(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		try{
			
			String ssoID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
			String lsSSO = StringUtil.checkNull(cmmMap.get("lsSSO"),"");
			
			model.put("olmI", ssoID);
			model.put("olmP", "");
			model.put("lsSSO", lsSSO);

			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LSCmmActionController::mainpage::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/indexLS");
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
	 
	@RequestMapping(value = "/custom/ls/test.do")
	public String testLS(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)	throws Exception {
		return nextUrl("/sso/index");
		
	}
	
	@RequestMapping(value = "/custom/ls/test_sso.do")
	public String test_sso_LS(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)	throws Exception {
		return nextUrl("/sso/dologin");
		
	}
	
	@RequestMapping(value = "/custom/ls/acs.do")
	public String test_acs_LS(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)	throws Exception {
		return nextUrl("/sso/acs");
		
	}	
		
}
