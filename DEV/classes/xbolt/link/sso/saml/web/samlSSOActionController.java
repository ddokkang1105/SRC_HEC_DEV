package xbolt.link.sso.saml.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
/**
 * 삼양식품 서블릿 처리
 * @Class Name : samlSSOActionController.java
 * @Description : Saml SSO 컨트롤러
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
public class samlSSOActionController extends XboltController{
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;
	
	@RequestMapping(value="/link/sso/saml/olmSSOlogin.do")
	public String samlLogin(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		// login filter
		return "";
	}
	
	@RequestMapping(value="/link/sso/saml/olmSSOProcessing.do")
	public String olmSSOProcessing(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		// login processing filter
		return "";
	}
	
	@RequestMapping(value="/link/sso/saml/olmSSOfail.do")
	public String olmSSOfail(HashMap commandMap,ModelMap model) throws Exception{
		Map result = null;
		try{
			 // SAML SSO 관련 메세지 추가 
			commandMap.put("ERROR_CD","WM00001");
			result= commonService.select("error_SQL.error_message",commandMap);
			model.addAttribute(AJAX_RESULTMAP, result);
		} catch (Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/cmm/err/errorDetail");
	}
	
	@RequestMapping(value="/link/sso/saml/olmSSO.do")
	public String olmSSO(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{
			Map setData = new HashMap();
			Map userInfo = new HashMap();
			
			String empNo = "";
			
			HttpSession session = request.getSession(false);
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			
			String samlLinkParamSR = StringUtil.checkNull(request.getQueryString());
			if(session.getAttribute("samlLinkParamSR") != null && "".equals(samlLinkParamSR)) {
				samlLinkParamSR = StringUtil.checkNull(session.getAttribute("samlLinkParamSR"));
			}
			
			if (auth == null || "anonymousUser".equals(auth.getPrincipal())){
				// 인증 정보 없음 혹은 anonymousUser 일 경우 다시 login 창으로 
				if(!"".equals(samlLinkParamSR)) {
					session.setAttribute("samlLinkParamSR", samlLinkParamSR);
				}
				return "redirect:/link/sso/saml/olmSSOlogin.do";
			}
			else {
				
				empNo = StringUtil.checkNull(auth.getPrincipal());
				
				String langCode = StringUtil.checkNull(request.getParameter("language"),"1042");
				
				setData.put("extCode", langCode);
				langCode = commonService.selectString("common_SQL.getLanguageID", setData);
				setData.put("employeeNum", empNo);
				
				if(empNo != null && !empNo.isEmpty()) {
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
				}
				
				if(userInfo != null && !userInfo.isEmpty()) {
					model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
				}
				
				// SR Link
				if(!"".equals(samlLinkParamSR) && samlLinkParamSR.indexOf("&") > -1 && samlLinkParamSR.indexOf("=") > -1) {
					String defArcCode = "";
					String defTemplateCode = "";
					String docCategory = "";
					String srID = "";
					
					String[] pairs = samlLinkParamSR.substring(1).split("&");
			        for (String pair : pairs) {
			            String[] keyValue = pair.split("=");
			            if (keyValue.length == 2) {
			                String key = keyValue[0];
			                String value = keyValue[1];
			                
			                if("defArcCode".equals(key)) defArcCode = StringUtil.checkNull(value,"");
				            if("defTemplateCode".equals(key)) defTemplateCode = StringUtil.checkNull(value,"");
				            if("docCategory".equals(key)) docCategory = StringUtil.checkNull(value,"");
				            if("srID".equals(key)) srID = StringUtil.checkNull(value,"");
			            }
			        }
			        
			        model.put("srID", srID);
					model.put("defArcCode", defArcCode);
					model.put("defTemplateCode", defTemplateCode);
					model.put("docCategory", docCategory);
				}
				
				model.put("olmLng",langCode);
				model.put("IS_CHECK", "N");	
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("pwdCheck", StringUtil.checkNull(cmmMap.get("pwdCheck"),""));
				
				// saml sr link
				if(session.getAttribute("samlLinkParamSR") != null) {
					session.removeAttribute("samlLinkParamSR");
				}
				// saml Link
				if(session.getAttribute("samlLinkParam") != null) {
					String samlLinkParam = StringUtil.checkNull(session.getAttribute("samlLinkParam"),"");
					session.removeAttribute("samlLinkParam");
					return "redirect:/link/sso/saml/olmSSOLink.do?" + samlLinkParam;
				}
				
			}
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("samlSSOActionController::SSO Login ::Error::"+e);}
			throw new ExceptionUtil("indexSSO ERROR :: " + e.toString());
		}		
		return nextUrl("indexSSO");
	}
	
	@RequestMapping(value="/link/sso/saml/olmSSOLink.do")
	public String olmSSOLink(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String url = "/template/olmLinkPopup";
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		
		// SSO
		HttpSession session = request.getSession(false);
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		if (auth == null || "anonymousUser".equals(auth.getPrincipal())){
			String queryString = request.getQueryString();
			session.setAttribute("samlLinkParam", queryString);
			return "redirect:/link/sso/saml/olmSSOlogin.do";
		}
		else {
			String empNo = StringUtil.checkNull(auth.getPrincipal());
			model.put("olmI", empNo);
			model.put("DEFAULT_LANG_CODE", defaltLangCode);
			
			if(session.getAttribute("samlLinkParam") != null) {
				session.removeAttribute("samlLinkParam");
			}
		}
		
		return nextUrl(url);
	}
	
	
	
}
