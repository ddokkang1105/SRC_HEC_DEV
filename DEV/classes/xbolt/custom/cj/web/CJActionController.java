package xbolt.custom.cj.web;

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
 * @Class Name : CJActionController.java
 * @Description : CJActionController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2016. 12. 14. smartfactory		최초생성
 *
 * @since 2016. 12. 14.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class CJActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;
	
	@RequestMapping(value="/cj/logincjForm.do")
	public String logincjForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		model=setLoginScrnInfo(model,cmmMap);
		return nextUrl("custom/cj/login");
	}
	
	@RequestMapping(value="/cj/logincj.do")
	public String logincj(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
				HttpSession session = request.getSession(true);
				Map resultMap = new HashMap();
				String langCode = GlobalVal.DEFAULT_LANG_CODE;	
				String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
				String screenType = StringUtil.checkNull(cmmMap.get("screenType"),StringUtil.checkNull(cmmMap.get("screenType")) );
				if(languageID.equals("")){
					languageID = GlobalVal.DEFAULT_LANGUAGE;
				}
				
				cmmMap.put("LANGUAGE", languageID);
				String cjmsg = "Your ID does not exist in our system. Please contact system administrator(CJWISE).";
				String ref = request.getHeader("referer");
				String protocol = request.isSecure() ? "https://" : "http://";
				
				String IS_CHECK = GlobalVal.PWD_CHECK;
				String url_CHECK = StringUtil.chkURL(ref, protocol);

				if("".equals(IS_CHECK))
					IS_CHECK = "Y";
				
				if("".equals(url_CHECK)) {
					if(screenType.equals("link")){
						resultMap.put(AJAX_SCRIPT, "fnReload('N')"); 
					}else{ 
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						resultMap.put(AJAX_ALERT, "Your ID does not exist in our system. Please contact system administrator(CJWISE).");
					}					
				}
				else {
					Map idInfo = new HashMap();
					idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				
					if(idInfo == null || idInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						resultMap.put(AJAX_ALERT, "Your ID does not exist in our system. Please contact system administrator(CJWISE).");		
					}
					else {
						aesAction = new AESUtil();
						cmmMap.put("LOGIN_ID", idInfo.get("LoginId"));
						String pwd = (String) cmmMap.get("PASSWORD");

						if("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
							if("Y".equals(GlobalVal.PWD_ENCODING)) {
								aesAction.setIV(request.getParameter("iv"));
								aesAction.setSALT(request.getParameter("salt"));
								
								pwd =  aesAction.decrypt(pwd);
													
								aesAction.init();
								
								pwd = aesAction.encrypt(pwd);
							}
	
							cmmMap.put("PASSWORD", pwd); 
							cmmMap.put("IS_CHECK", "Y");
						}
						else {
							cmmMap.put("IS_CHECK", "N");
						}
						
						
						Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
						if(loginInfo == null || loginInfo.size() == 0) {
							resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
							resultMap.put(AJAX_ALERT, "Password is wrong.");			
						}
						else {
							// [Authority] < 4 인 경우, 수정가능하게 변경
							if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
							else	loginInfo.put("loginType", "viewer");	
							resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");		
							session.setAttribute("loginInfo", loginInfo);
						}
					}
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			    model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
			    model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
			    model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
				model.addAttribute(AJAX_RESULTMAP,resultMap);
				
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	private ModelMap setLoginScrnInfo(ModelMap model,HashMap cmmMap) throws ExceptionUtil {
		Map setMap = new HashMap();
		String loginID = StringUtil.checkNull(cmmMap.get("loginID"));
		String language = StringUtil.checkNull(cmmMap.get("language"));
		setMap.put("extCode", language);
		try {
			String languageID = StringUtil.checkNull(commonService.selectString("common_SQL.getLanguageID",setMap),"");		
			model.addAttribute("loginid",loginID);
			model.addAttribute("lng",languageID);
			
			if(_log.isInfoEnabled()){_log.info("setLoginScrnInfo : loginid="+StringUtil.checkNull(cmmMap.get("loginid"))+",lng="+StringUtil.checkNull(cmmMap.get("lng")));}		  
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
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
		
		return model;
 	}
	
/**
	 * downloadProcessList
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/downloadAllCJProcData.do")
	public String downloadAllCJProcData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/custom/cj/report/downloadAllProcData");
	}
	@RequestMapping(value="/downloadCJProcData.do")
	public String downloadCJProcData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/custom/cj/report/downloadProcData");
	}
	
}
