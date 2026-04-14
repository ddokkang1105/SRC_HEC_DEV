package xbolt.link.sso.ms.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.link.sso.ms.helpers.AuthHelper;
import xbolt.link.sso.ms.helpers.GraphHelper;
import xbolt.link.sso.ms.helpers.IdentityContextAdapterServlet;

import com.microsoft.aad.msal4j.IAccount;
import com.microsoft.graph.models.User;
/**
 * 
 * @Class Name : msSSOActionController.java
 * @Description : ms AD oAuth2 SSO 컨트롤러
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
public class msSSOActionController extends XboltController{
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;
	
	@RequestMapping(value="/link/sso/ms/olmSSO.do")
	public String olmSSO(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{
			Map setData = new HashMap();
			Map userInfo = new HashMap();
			String auth = StringUtil.checkNull(request.getAttribute("isAuthenticated"));
			String userId = ""; //email
			String employeeNum = ""; //
			
			if("false".equals(auth) || auth == null  || ("").equals(auth)){
				return "redirect:/auth/sign_in";
			} else {
				
				// user.read 옵션이 있어야함.
				IdentityContextAdapterServlet contextAdapter = new IdentityContextAdapterServlet(request, response);
		        AuthHelper.acquireTokenSilently(contextAdapter);
		        User user = GraphHelper.getGraphClient(contextAdapter).me().buildRequest().select("employeeId").get();
		        employeeNum = StringUtil.checkNull(user.employeeId);
		        
		        IAccount account = (IAccount) request.getAttribute("account");
		        userId = StringUtil.checkNull(account.username());
			}
			
			String langCode = StringUtil.checkNull(request.getParameter("language"),"");
			
			setData.put("extCode", langCode);
			langCode = commonService.selectString("common_SQL.getLanguageID", setData);
			
			// 이메일 제거
			if(userId != null && !userId.isEmpty()) {
				
				if("".equals(employeeNum) || employeeNum == null){
					int atIndex = userId.indexOf('@');
					if (atIndex != -1) {
						employeeNum = userId.substring(0,atIndex);
					}
				}
				setData.put("employeeNum", employeeNum);
				userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
			}
			
			if(userInfo != null && !userInfo.isEmpty()) {
				model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
			}
			
			model.put("olmLng",langCode);
			model.put("IS_CHECK", "N");	
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("pwdCheck", StringUtil.checkNull(cmmMap.get("pwdCheck"),""));
			model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
			model.put("defTemplateCode", StringUtil.checkNull(cmmMap.get("defTemplateCode"),""));
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("msSSOActionController::SSO Login ::Error::"+e);}
			throw new ExceptionUtil("olmSSO ERROR :: " + e.toString());
		}		
		return nextUrl("indexSSO");
	}
	
	// TODO
	@RequestMapping(value="/link/sso/ms/olmSSOLink.do")
	public String olmSSOLink(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String url = "/template/olmLinkPopup";
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		Map setData = new HashMap();
		Map userInfo = new HashMap();
		
		String auth = StringUtil.checkNull(request.getAttribute("isAuthenticated"));

		if("false".equals(auth) || auth == null  || ("").equals(auth)){
			return "redirect:/auth/sign_in";
		}
		else {
			
			IAccount account = (IAccount) request.getAttribute("account");
			String userId = StringUtil.checkNull(account.username());
			
			int atIndex = userId.indexOf('@');
			if(userId != null && !userId.isEmpty()) {
				if (atIndex != -1) {
		            String employeeNum = userId.substring(0,atIndex);
					setData.put("employeeNum", employeeNum);
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
		        }
			}
			
			if(userInfo != null && !userInfo.isEmpty()) {
				model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
			}
			
			model.put("DEFAULT_LANG_CODE", defaltLangCode);
			
		}
		
		return nextUrl(url);
	}
	
	
	
}
