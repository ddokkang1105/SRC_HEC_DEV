package xbolt.custom.samsung.cmm;

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
// import xbolt.custom.samsung.cmm.SEMESSsoUtils;

/**
 * @Class Name : LoginSEMESActionController.java
 * @Description : LoginSEMESActionController.java
 * @Modification Information
 * @수정일수정자 수정내용
 * @--------- --------- -------------------------------
 * @2016. 12. 14. smartfactory최초생성
 *
 * @since 2016. 12. 14.
 * @version 1.0
 * @see
 */
@Controller
@SuppressWarnings("unchecked")
public class LoginSamsungActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/samsungSSO.do")
	public String semesSSO(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		return nextUrl("custom/samsung/cmm/sso");
	}
	
	@RequestMapping(value="/loginsamsungSSO.do")
	public String loginsemesSSO(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			HttpSession session = request.getSession(true);
			Map resultMap = new HashMap();
			String langCode = GlobalVal.DEFAULT_LANG_CODE;
			String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
			if(languageID.equals("")){
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}
			
			cmmMap.put("LANGUAGE", languageID);
			
			Map idInfo = new HashMap();
			Map setMap = new HashMap();
			
			setMap.put("LANGUAGE", languageID);
			setMap.put("LOGIN_ID",StringUtil.checkNull(cmmMap.get("EP_LOGINID")));
			
			idInfo = commonService.select("login_SQL.login_id_select", setMap);
			
			String msg = "Please contact system administrator.";
			
			if(idInfo == null || idInfo.size() == 0) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT, msg);
			}
			else {
				setMap.put("IS_CHECK","N");
			
				Map loginInfo = commonService.select("login_SQL.login_select", setMap);
				if(loginInfo == null || loginInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					resultMap.put(AJAX_ALERT, msg);
				}
				else {
					// [Authority] < 4 인 경우, 수정가능하게 변경
					if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0) loginInfo.put("loginType", "editor");
					else loginInfo.put("loginType", "viewer");
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
}
