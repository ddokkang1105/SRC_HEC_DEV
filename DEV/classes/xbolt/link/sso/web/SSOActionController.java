package xbolt.link.sso.web;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
 * 삼양식품 서블릿 처리
 * @Class Name : SSOActionController.java
 * @Description : SSO 컨트롤러
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2023.12 .29. Smartfactory		최초생성
 *
 * @since 2023. 12. 29.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SSOActionController extends XboltController{

	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;
	
	@RequestMapping(value="/link/sso/olmSSOForm.do")
	public String loginSSOForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setSSOScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("docCategory", cmmMap.get("docCategory"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("status", cmmMap.get("status"));
	  model.put("pwdCheck", cmmMap.get("pwdCheck"));
	  model.put("defArcCode", cmmMap.get("defArcCode"));
	  model.put("defTemplateCode", cmmMap.get("defTemplateCode"));
	  
	  return nextUrl("/cmm/sso/login");
	}
	
	@RequestMapping(value="/link/sso/olmSSO.do")
	public String loginSSO(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
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
			
			String IS_CHECK2 = StringUtil.checkNull(cmmMap.get("IS_CHECK"),"");
			String IS_CHECK = GlobalVal.PWD_CHECK;
			
			if("".equals(IS_CHECK))
				IS_CHECK = "Y";
			
			if("N".equals(IS_CHECK2))
				IS_CHECK = "N";
			
			cmmMap.put("IS_CHECK", IS_CHECK);
			String url_CHECK = StringUtil.chkURL(ref, protocol);
			String pwdCheck = StringUtil.checkNull(cmmMap.get("pwdCheck"),"");
			
			if("".equals(url_CHECK)) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
			}
			else {		
				Map idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				if(idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
				}
				else {
					aesAction = new AESUtil();
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId"));
					
					if("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
						cmmMap.put("IS_CHECK", "Y");
					}
					else if (pwdCheck.equals("N")){
						cmmMap.put("IS_CHECK", "N");
					}
					
					String pwd = (String) cmmMap.get("PASSWORD");
					
					if("Y".equals(GlobalVal.PWD_ENCODING)) {
						aesAction.setIV(request.getParameter("iv"));
						aesAction.setSALT(request.getParameter("salt"));
						
						pwd =  aesAction.decrypt(pwd);
											
						aesAction.init();
						
						pwd = aesAction.encrypt(pwd);
					}
	
					cmmMap.put("PASSWORD", pwd); 
					
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
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				model.addAttribute(AJAX_RESULTMAP,resultMap);
			}
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}	
	

	private ModelMap setSSOScrnInfo(ModelMap model,HashMap cmmMap) throws Exception {
		  
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

}