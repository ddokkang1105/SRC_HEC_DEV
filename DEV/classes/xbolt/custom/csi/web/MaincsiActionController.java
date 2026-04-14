package xbolt.custom.csi.web;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * 공통 서블릿 처리
 * @Class Name : MaincsiActionController.java
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
public class MaincsiActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;

	@RequestMapping(value="/indexADCSI.do")
	public String indexADCSI(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
			model.put("olmLng",GlobalVal.DEFAULT_LANGUAGE);
			model.put("IS_CHECK", "N");	
			model.put("AD", "Y");	
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("wfInstanceID", StringUtil.checkNull(cmmMap.get("wfInstanceID"),""));
			model.put("pwdCheck", StringUtil.checkNull(cmmMap.get("pwdCheck"),""));
			model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
			model.put("defTemplateCode", StringUtil.checkNull(cmmMap.get("defTemplateCode"),""));
			
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MaincsiActionController::CSI Login ::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexCSI");
	}
	/**
	 * 필터에 추가 하거나 위의 것과 병합
	 * */
	@RequestMapping(value="/indexCSI.do", method=RequestMethod.POST)
	public String indexCSI(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
				Map setData = new HashMap();
				Map userInfo = new HashMap();
				
				String loginID = StringUtil.checkNull(request.getParameter("loginID"),"");
				String langCode = StringUtil.checkNull(request.getParameter("language"),"");
				
				setData.put("extCode", langCode);
				langCode = commonService.selectString("common_SQL.getLanguageID", setData);
				setData.put("loginID", loginID);
				
				if(loginID != null && !loginID.isEmpty()) {
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
				}
				
				if(userInfo != null && !userInfo.isEmpty()) {
					model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
				}
				model.put("olmLng",langCode);
				model.put("IS_CHECK", "N");		
				model.put("AD", "N");	
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
				model.put("pwdCheck", StringUtil.checkNull(cmmMap.get("pwdCheck"),""));
				model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
				model.put("defTemplateCode", StringUtil.checkNull(cmmMap.get("defTemplateCode"),""));
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MaincsiActionController::CSI Login ::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexCSI");
	}
	
	@RequestMapping(value="csi/login/logincsiForm.do")
	public String logincsiForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setcsiLoginScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
	  model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
	  model.put("wfInstanceID", StringUtil.checkNull(cmmMap.get("wfInstanceID"),""));
	  model.put("status", cmmMap.get("status"));
	  model.put("AD", cmmMap.get("AD"));
	  model.put("pwdCheck", cmmMap.get("pwdCheck"));
	  
	  model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
	  model.put("defTemplateCode", StringUtil.checkNull(cmmMap.get("defTemplateCode"),""));
	  
	  return nextUrl("custom/csi/login");
	}
	
	@RequestMapping(value="/csi/login/logincsi.do")
	public String logincsi(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
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
			boolean isSuccess = true;
			String AD = StringUtil.checkNull(cmmMap.get("AD"),"");
			
			if("".equals(IS_CHECK))
				IS_CHECK = "Y";
			
			if("N".equals(IS_CHECK2))
				IS_CHECK = "N";
			
			cmmMap.put("IS_CHECK", IS_CHECK);
			String url_CHECK = StringUtil.chkURL(ref, protocol);
			String pwdCheck = StringUtil.checkNull(cmmMap.get("pwdCheck"),"");

			if(!AD.equals("N")) {
				AdLogin ADSSO = new AdLogin();
				String loginID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
				String password = StringUtil.checkNull(cmmMap.get("PASSWORD"),"");
				isSuccess = ADSSO.loginAD(loginID, password);
				System.out.println("isSuccess == "+isSuccess);
			}
			
			if("".equals(url_CHECK) || isSuccess == false) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
			}
			else {
				Map idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				if(idInfo == null || idInfo.size() == 0 || isSuccess == false) {
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
					if(loginInfo == null || loginInfo.size() == 0 || isSuccess == false) {
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
			}
			model.addAttribute(AJAX_RESULTMAP,resultMap);
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	private ModelMap setcsiLoginScrnInfo(ModelMap model,HashMap cmmMap) throws Exception {
		  
	  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
	  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
	  model.addAttribute("pwd",pass);
	  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
	  
	  if(_log.isInfoEnabled()){
		  _log.info("setLoginScrnInfo : loginid="+StringUtil.checkNull(cmmMap.get("loginid"))+",pass"+URLEncoder.encode(pass)+",lng="+StringUtil.checkNull(cmmMap.get("lng")));
	  }		  
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
	
	@RequestMapping(value="/zcsi_MainHome.do")
	public String mainHomecsi(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {		
		try {
			Map setMap = new HashMap();
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	setMap.put("languageID", languageID);
	    	
	    	setMap.put("level", "L1");
	    	setMap.put("itemID",100114);
	    	String CNTof100114 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",115875);
	    	String CNTof115875 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",100118);
	    	String CNTof100118 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",107367);
	    	String CNTof107367 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",100122);
	    	String CNTof100122 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",100124);
	    	String CNTof100124 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",100126);
	    	String CNTof100126 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",100128);
	    	String CNTof100128 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	setMap.put("itemID",100130);
	    	String CNTof100130 = commonService.selectString("report_SQL.getItemCntByLevel", setMap);
	    	
	    	model.put("CNTof100114",CNTof100114);
	    	model.put("CNTof115875",CNTof115875);
	    	model.put("CNTof100118",CNTof100118);
	    	model.put("CNTof107367",CNTof107367);
	    	model.put("CNTof100122",CNTof100122);
	    	model.put("CNTof100124",CNTof100124);
	    	model.put("CNTof100126",CNTof100126);
	    	model.put("CNTof100128",CNTof100128);
	    	model.put("CNTof100130",CNTof100130);
			model.put("menu", getLabel(request, commonService));
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		return nextUrl("/custom/csi/mainHomecsi");
	}
	
	@RequestMapping(value="custom/csi/zcsi_olmLinkMaster.do")
	public String olmLinkMaster(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {		
		return indexADCSI(cmmMap,model,request);
	}
}
