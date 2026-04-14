package xbolt.custom.daelim.univ.web;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
/**
 * 공통 서블릿 처리
 * @Class Name : MainDaelimActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2019.01 .08. Smartfactory		최초생성
 *
 * @since 2019. 01. 08.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MainDaedlimUNVActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;

	@RequestMapping(value="/daelim/index.do")
	public String daelimIndex(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		try{
			String ssoID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");

			model.put("olmI", ssoID);
			model.put("olmP", "");
			
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainDaedlimUNVActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/custom/daelim/unv/index");
	}
		
	@RequestMapping(value="/daelim/loginDaelimForm.do")
	public String loginDaelimForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setLoginScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("proposal", cmmMap.get("proposal"));
	  model.put("status", cmmMap.get("status"));
	  return nextUrl("/custom/daelim/unv/login");
	}
		
	@RequestMapping(value="/daelim/loginDaelim.do")
	public String loginDaelim(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
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
					resultMap.put(AJAX_ALERT, "Your ID does not exist in our system. Please contact system administrator.");
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
			if(_log.isInfoEnabled()){_log.info("MainDaedlimUNVActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
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
	
	@RequestMapping(value="/daelim/sso/index.do")
	public String ssoindex(Map cmmMap, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {
		return nextUrl("/custom/daelim/unv/sso/business");		
	}	
	
	@RequestMapping(value="/daelim/sso/login.do")
	public String ssoLogin(Map cmmMap, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {
		return nextUrl("/custom/daelim/unv/sso/login");		
	}	
	
	@RequestMapping(value="/daelim/sso/logout.do")
	public String ssoLogout(Map cmmMap, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {
		return nextUrl("/custom/daelim/unv/sso/logout");		
	}	
	
	@RequestMapping(value="/daelim/sso/agentProc.do")
	public String ssoAgentProc(Map cmmMap, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {
		return nextUrl("/custom/daelim/unv/sso/agentProc");		
	}	
	
	@RequestMapping(value="/daelim/sso/checkauth.do")
	public String ssoCheckauth(Map cmmMap, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {
		return nextUrl("/custom/daelim/unv/sso/checkauth");		
	}	
	
	@RequestMapping(value="/daelim/sso/checkserver.do")
	public String ssoCheckserver(Map cmmMap, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {
		return nextUrl("/custom/daelim/unv/sso/checkserver");		
	}	
}
