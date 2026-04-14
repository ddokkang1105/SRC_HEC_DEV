package xbolt.custom.mando.web;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.aspose.words.BreakType;
import com.aspose.words.CellMerge;
import com.aspose.words.CellVerticalAlignment;
import com.aspose.words.Document;
import com.aspose.words.DocumentBuilder;
import com.aspose.words.HeaderFooterType;
import com.aspose.words.HeightRule;
import com.aspose.words.License;
import com.aspose.words.PageSetup;
import com.aspose.words.PaperSize;
import com.aspose.words.ParagraphAlignment;
import com.aspose.words.PreferredWidth;
import com.aspose.words.RelativeHorizontalPosition;
import com.aspose.words.RelativeVerticalPosition;
import com.aspose.words.Section;
import com.aspose.words.TabAlignment;
import com.aspose.words.WrapType;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.MakeWordReport;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.project.chgInf.web.CSActionController;
import xbolt.project.pjt.web.ProjectActionController;
import xbolt.rpt.web.ReportActionController;

import java.awt.Color;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.spec.InvalidKeySpecException;
import java.text.SimpleDateFormat;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import xbolt.custom.mando.val.MDGlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.framework.val.GlobalVal;
/**
 * @Class Name : MDController.java
 * @Description : MDController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2017. 03. 20. smartfactory		최초생성
 *
 * @since 2017. 03. 20.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MDActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "commonOraService")
	private CommonService commonOraService;
	private AESUtil aesAction;
	private Key keyMulticampus = null;
	private Cipher cipher = null;
	private DESedeKeySpec kspec = null;
	private SecretKeyFactory skf= null;
	private SecretKeySpec skfAES = null;
	private String keyvalue = null;	
	
	private String wfKey = "00003WPUQ7AH9DX"; 
	
	@Resource(name = "reportActionController")
	private ReportActionController reportActionController;
	
	@Resource(name = "CSActionController")
	private CSActionController CSActionController;
	

	public MDActionController() {
		try {	
			this.cipher = Cipher.getInstance("DESede");
			this.skf= SecretKeyFactory.getInstance("DESede");			
			this.skfAES = new SecretKeySpec(("3567125684009065".getBytes("UTF-8")), "AES");
			this.setKey(GlobalVal.PWD_KEY);	
		} catch(Exception e) {
			
		}
	}
	
	
	public void setKey(String in) throws InvalidKeyException, InvalidKeySpecException{
	  keyvalue = in;
	  kspec = new DESedeKeySpec(keyvalue.getBytes());
	  keyMulticampus = skf.generateSecret(kspec);
	 }    
	
	@RequestMapping(value="/mainHomeMando.do")
	public String mainHomeMando(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {		
		try {
			Map setMap = new HashMap();
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	setMap.put("languageID", languageID);

			List nameList = (List)commonService.selectList("custom_SQL.getMainItemName", setMap);
			
			model.put("nameList", nameList);
			model.put("menu", getLabel(request, commonService));
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		return nextUrl("/custom/mando/mainHomeMando");
	}
	
	@RequestMapping(value="/zmd_MainChangeSetList.do")
	public String zmd_MainChangeSetList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			setMap.put("mainYN", "Y");
			setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"),"1042"));
			setMap.put("DimValueID", StringUtil.checkNull(request.getParameter("memberState"),"MDK"));
			setMap.put("isNotIn", "N");
			setMap.put("DimTypeID", "100001");
			
			List chgSetList = (List)commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);
			String isView="0";if(chgSetList!=null && chgSetList.size()>0){isView="1";}
			model.put("chgSetList", chgSetList);
			model.put("isView", isView);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/custom/mando/zmd_MainChangeSetList");
	}
	
	
	@RequestMapping(value="/indexMD.do")
	public String indexMD(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{				
				Map setData = new HashMap();
				Map userInfo = new HashMap();
				
				Map resultMap = new HashMap();
				String PM_SABUN = request.getParameter("PM_SABUN");

				String langCode = (String) cmmMap.get("language");
				
				setData.put("extCode", langCode);
				
				langCode = commonService.selectString("common_SQL.getLanguageID", setData);
				HashMap mdsso = checkPmSabun(PM_SABUN);
				if(!mdsso.get("errM").equals("NoError")) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
					
					model.addAttribute(AJAX_RESULTMAP,resultMap);
					
					return nextUrl("indexMD");
				}
				setData.put("employeeNum", mdsso.get("empNo"));
				
				userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
			
				if(userInfo != null && !userInfo.isEmpty()) {	
					String activeYN = "N";
					HashMap setMap = new HashMap();
					
					setMap.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));
					
					activeYN = commonService.selectString("login_SQL.login_active_select", setMap);
					if(!"Y".equals(activeYN)) {
						return nextUrl("indexMD");
					}
					
					model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
				}
				
				model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("languageID", langCode);
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
				model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"),""));
				model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MandoActionController::Mando Login ::Error::"+e);}
						
			return nextUrl("indexMD");	
		}		
		return nextUrl("indexMD");
	}
	
	@RequestMapping(value="/mando/loginmandoForm.do")
	public String loginmandoForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  HttpSession session = request.getSession(true);
	  
	  Map loginInfo = (Map)session.getAttribute("loginInfo");

	  if(loginInfo != null && !loginInfo.isEmpty()) {
		  	if("guest".equals(loginInfo.get("sessionLoginId"))) {
		  		session.invalidate();
				model.put("ssoYN", "N");
		  	}
		  	else {
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
				model.put("ssoYN", "Y");
		  	}
	  }
	  else {
			model.put("ssoYN", "N");
	  }

	  model=setLoginScrnInfo(model,cmmMap);
	  //String test = commonOraService.selectString("lf_ORASQL.getCheckLogSso1", loginInfo);
	  
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("sysCode", cmmMap.get("sysCode"));
	  model.put("proposal", cmmMap.get("proposal"));
	  model.put("status", cmmMap.get("status"));
	  return nextUrl("/custom/mando/login");
	}
		
	//만도의 경우 SSO외 직접 로그인 시 패스워드 암호화 하여 로그인 체크 함
	@RequestMapping(value="/mando/loginmando.do")
	public String loginmando(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
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
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
				}
				else {
					Map idInfo = new HashMap();
					idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				
					if(idInfo == null || idInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
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
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			    model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
			    model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
			    model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
				model.addAttribute(AJAX_RESULTMAP,resultMap);
		}
		catch (Exception e) {
			System.out.println(e.toString());
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	//만도 SSO 함수에서 사용
	@RequestMapping(value="/mando/createSABUN.do")
	public String createSABUN(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		
		cipher.init(Cipher.ENCRYPT_MODE, keyMulticampus);
		Calendar calendar = Calendar.getInstance();
		String pm_sabun = request.getParameter("PM_SABUN");
		Date date = calendar.getTime();
		long today = Long.parseLong(new SimpleDateFormat("yyyyMMddHHmmss").format(date));
		String system = MDGlobalVal.MND_SYS_KEY;
		String contents =  MDGlobalVal.MND_CONTENTS;
		
		String sabun = "ts="+String.valueOf(today)+"&system="+system+"&contents="+contents+"&empNo="+pm_sabun;
		sabun = ((new BASE64Encoder()).encode(cipher.doFinal(sabun.getBytes()))).replaceAll("\r\n","");
		
		model.put("sabun",sabun);
		return nextUrl("/custom/mando/createSABUN");
	}
	
	@RequestMapping(value="/updateRefObjectID.do")
	public String updateRefObjectID(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();		
		try{
			Map setData = new HashMap();
			commonService.insert("custom_SQL.updateL5RefLinkIDMD", setData);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "");
	
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); 
		} 
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);	
	}
	
	private ModelMap setLoginScrnInfo(ModelMap model,HashMap cmmMap) throws ExceptionUtil {
		  
	  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
	  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
	  model.addAttribute("pwd",pass);
	  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
	  try {
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
	  } catch(Exception e) {
		  throw new ExceptionUtil(e.toString());
	  }
	  return model;
 	}
	
	public String encrypt3DES(String input) throws InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
		cipher.init(Cipher.ENCRYPT_MODE, keyMulticampus);
		return ((new BASE64Encoder()).encode(cipher.doFinal(input.getBytes()))).replaceAll("\r\n","");
	}
 
	public String decrypt3DES(String input) throws InvalidKeyException, BadPaddingException, IllegalBlockSizeException, IOException {
		byte[] encryptionBytes = new BASE64Decoder().decodeBuffer(input);
		cipher.init(Cipher.DECRYPT_MODE, keyMulticampus);
		return  new String(cipher.doFinal(encryptionBytes));
	}  
		
	@RequestMapping(value="/runMDTransaction.do")
	public String runMDTransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();	
		String url = "/custom/mando/runMDTransaction";
	    try {
	    		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
	    		String itemID = StringUtil.checkNull(request.getParameter("itemID"));
	    		String systemType = "";
	    		String MD_URL = "";	  		   
	    		String attrTypeCode = "AT00037";//StringUtil.checkNull(cmmMap.get("lovCode"),"LV37002"); 		
				String functionId = StringUtil.checkNull(cmmMap.get("function_id"),"44793");
				String securityGroupId = StringUtil.checkNull(cmmMap.get("security_group_id"),"0");
				
				String userName = StringUtil.checkNull(cmmMap.get("sessionUserId"),"");
				String formId = "";
				//System.out.println(cmmMap.toString());
				
	    		/**
	    		ERP => http://gerptap1.mando.com:8060/OA_HTML/RF.jsp?function_id=44793&resp_id=51065&resp_appl_id=660&security_group_id=0&lang_code=US
	    		EAC => http://eac.mando.com:8010/ea/login/loginUserIdCheck.do?userName=EACUSER&targetName=BPMS&formId=1003
	    		ERP_SSO => http://gerptap1.mando.com:8020/OA_HTML/fndvald.jsp?username=P12360&password=11111
				**/
				setMap.put("languageID", languageID);
				setMap.put("itemID", itemID);	
				setMap.put("attrTypeCode", attrTypeCode);			
				systemType = StringUtil.checkNull(commonService.selectString("custom_SQL.getSystemType", setMap),"ERP");
				
				String langCode = StringUtil.checkNull(commonService.selectString("custom_SQL.getExtCode", setMap),"US");
				String sso_URL = "";
				
	    		formId = commonService.selectString("attr_SQL.getItemSysName", setMap);
	    		// ERP URL 가져오기 
	    		if(systemType.equals("LV37011")){
	    			
					Map erpInfo = new HashMap();
					Map erpSSO = new HashMap();
					
					setMap.put("functionID", formId);
					setMap.put("userID", userName);
					
					setMap.put("MemberID", cmmMap.get("sessionUserId"));
					String empNum = commonService.selectString("user_SQL.getEmployeeNum", setMap);
					setMap.put("empNum", empNum);
					erpInfo = commonService.select("custom_SQL.getERPDataInfo", setMap);
					erpSSO = commonService.select("custom_SQL.getERPUserInfo", setMap);
					sso_URL = MDGlobalVal.WEB_SSO_URL+"?username="+erpSSO.get("LOGIN_ID")+"&password="+erpSSO.get("LOGIN_PWD");
					//sso_URL = MDGlobalVal.WEB_SSO_URL+"?username=MHCOM&password=12345";
					MD_URL = MDGlobalVal.WEB_ERP_URL+"?function_id="+erpInfo.get("function_ID")+"&resp_id="+erpInfo.get("RESPONSIBILITY_ID")+"&resp_appl_id="+erpInfo.get("APPLICATION_ID")+"&security_group_id="+securityGroupId+"&lang_code="+langCode;
						
		    		model.put("ssoUrl", sso_URL); 
		    		model.put("ssoYN", "Y");
	    		}
	    		else if(systemType.equals("LV37006")){
	    			
					setKey("010187000345600238600893");
	    			cipher.init(Cipher.ENCRYPT_MODE, keyMulticampus);
	    			Calendar calendar = Calendar.getInstance();
					Date date = calendar.getTime();
					long today = Long.parseLong(new SimpleDateFormat("yyyyMMddHHmmss").format(date));
					
					setMap.put("userID", userName);
					String empNo = StringUtil.checkNull(commonService.selectString("user_SQL.getEmployeeNum", setMap));
					String sabun = "ts="+String.valueOf(today)+"&system="+MDGlobalVal.MND_SYS_KEY+"&contents="+MDGlobalVal.MND_CONTENTS+"&empNo="+empNo;
					sabun = ((new BASE64Encoder()).encode(cipher.doFinal(sabun.getBytes()))).replaceAll("\r\n","");
					
	    			MD_URL = MDGlobalVal.WEB_EAC_URL;
	    			MD_URL += "?formId="+formId+"&";
	    			model.put("parameter", "PM_SABUN");	    			 
	    			model.put("pm_value", sabun);
	    		}
	    		
	    		model.put("url", MD_URL);
	    		
	    }catch (SQLException se) {
			if(_log.isInfoEnabled()){_log.info("MDActionController::runOracleERP::Error::"+se);}
			throw new ExceptionUtil(se.toString());
		}	   
		return nextUrl(url);
	}
	
	
	@RequestMapping(value="/olmLinkMD.do")
	public String olmLinkMD(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		Map loginMap = new HashMap();
		
		Map resultMap = new HashMap();
		Map setMap = new HashMap();
		
		String pm_sabun = (String) cmmMap.get("PM_SABUN");
		String langCode = (String) cmmMap.get("language");
		
		setMap.put("extCode", langCode);
		
		langCode = commonService.selectString("common_SQL.getLanguageID", setMap);
				
		HashMap mdsso = checkPmSabun(pm_sabun);
		if(!mdsso.get("errM").equals("NoError")) {
			resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
			//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
			resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
			
			model.addAttribute(AJAX_RESULTMAP,resultMap);
			
			return nextUrl("indexMD");
		}
		model.put("p1", mdsso.get("empNo"));
		model.put("employeeNum", mdsso.get("empNo"));
		
		model.put("object", cmmMap.get("object"));
		model.put("linkType", cmmMap.get("linkType"));
		model.put("linkID", cmmMap.get("linkID"));
		model.put("iType", cmmMap.get("iType"));
		model.put("source", cmmMap.get("source"));
		
		loginMap = commonService.select("common_SQL.getLoginIDFromMember", model);
		
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
						
		if(loginMap.get("LoginId") != null && loginMap.get("LoginId") != "" && !loginMap.get("LoginId").equals(""))			
			model.put("loginCheck", "1");
			
		model.put("loginid", loginMap.get("LoginId"));
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		model.put("olmLng", langCode);
		model.put("IS_CHECK", "N");
		
		return nextUrl("/custom/mando/olmLinkPopup");
	}
	
	public HashMap checkPmSabun(String PM_SABUN) {
		HashMap mdSSO = new HashMap();
		try {
			
			setKey(GlobalVal.PWD_KEY);
			if(PM_SABUN == null || PM_SABUN == "" || PM_SABUN.equals("")) {
				mdSSO.put("errM", "noSabunError");
			}
			
			PM_SABUN = decrypt3DES(PM_SABUN); // 해당값의 유효성 체크
			String[] loginInfo = PM_SABUN.split("&");
			
			for(int i=0; i<loginInfo.length; i++) {
				String[] sso = loginInfo[i].split("=");
				if(sso != null)
					mdSSO.put(sso[0], sso[1]);
			}
			
			String ts = (String) mdSSO.get("ts");
			String system = (String) mdSSO.get("system");
			String contents = (String) mdSSO.get("contents");
			String empNo = (String) mdSSO.get("empNo");
			
			if(system == null || system.equals("") || !system.equals(MDGlobalVal.MND_SYS_KEY)) {
				mdSSO.put("errM", "sysCodeError");
			}
							
			if(contents == null || contents.equals("") || !contents.equals(MDGlobalVal.MND_CONTENTS)) {				
				mdSSO.put("errM", "conCodeError");
			}
											
			if(ts != null && !ts.equals("")) {
				long afterTime = Long.parseLong(ts) - 1000;
				long beforeTime = Long.parseLong(ts) + 1000;
				Calendar calendar = Calendar.getInstance();
				Date date = calendar.getTime();
				long today = Long.parseLong(new SimpleDateFormat("yyyyMMddHHmmss").format(date));
				/*
				if(today < afterTime || today > beforeTime)	{			
					mdSSO.put("errM", "timeCodeError");
				}
				*/
			}
			else {
				mdSSO.put("errM", "timeCodeError");
			}
							
			if(empNo == null || empNo.equals("")) { 
				mdSSO.put("errM", "empNoError");
			}
			
			mdSSO.put("errM", "NoError");
		}
		catch(Exception e) {
			mdSSO.put("errM", e);
		}
		
		return mdSSO;
	}
	
	@RequestMapping(value="/mdProcSummary.do")
	public String mdProcSummary(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			List returnData = new ArrayList();
			List prcArcList = new ArrayList();
			List L1List = new ArrayList();
			List L2List = new ArrayList();
			List L3List = new ArrayList();
			List L4List = new ArrayList();

			String L1ID = StringUtil.checkNull(request.getParameter("L1ID"));	
			String dimValue = StringUtil.checkNull(request.getParameter("dimValue"));	
			if(L1ID.equals("")){
				L1ID = "01";
			}
			setMap.put("dimValue",dimValue);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("L1ID", L1ID);
			L1List = (List) commonService.selectList("custom_SQL.getMNProcRootItem", setMap);			
			
			setMap.put("level", "CL01002");
			L2List = (List) commonService.selectList("custom_SQL.getMNProcSumList", setMap);
			setMap.put("level", "CL01004");
			L3List = (List) commonService.selectList("custom_SQL.getMNProcSumList", setMap);
			setMap.put("level", "CL01005");
			L4List = (List) commonService.selectList("custom_SQL.getMNProcSumList", setMap);
			
			model.put("prcTreeXml", setMandoProcessXML(L1List, L2List, L3List, L4List));
			model.put("L1ID", L1ID);
			model.put("dimValue", dimValue);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/custom/mando/mdProcSummary");
	}
	
	private String setMandoProcessXML(List L1List,List L2List,List L3List,List L4List) {
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_OPEN_CUSOR = "	<cell style='cursor:pointer;'>";
		String CELL_CLOSE = "</cell>";
		String CLOSE = ">";
		String CELL_TOT = "";
		String ROW_OPEN = "<row id=";
		String ROW_CLOSE = "</row>";
		
		String result = "<rows>";
		String resultRow = "";
		
		int rowIndex=0;			
		for (int j = 0; j < L1List.size(); j++) {
			Map L1Map = (HashMap) L1List.get(j);
						
			String L1ClassCode = StringUtil.checkNull(L1Map.get("Level")).trim();
			String L1PreTreeItemID = StringUtil.checkNull(L1Map.get("PRE_TREE_ID")).trim();
			String L1TreeItemID = StringUtil.checkNull(L1Map.get("TREE_ID")).trim();
			String L1TreeName =  StringUtil.checkNull(L1Map.get("TREE_NM")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " "); 
			
			resultRow += "<row id='" + L1PreTreeItemID +"."+ rowIndex+ "' open='1'>";	
			rowIndex++;
			resultRow += "		<cell image='img_process.png'>" + L1TreeName + CELL_CLOSE;
			resultRow += CELL_OPEN + L1PreTreeItemID + CELL_CLOSE;
			resultRow += CELL_OPEN + L1TreeItemID + CELL_CLOSE;

			int rowIndex2 = 0;
			for (int k = 0; k < L2List.size(); k++) {
				Map L2Map = (HashMap) L2List.get(k);
						
				String L2ClassCode = StringUtil.checkNull(L2Map.get("Level")).trim();
				String L2PreTreeItemID = StringUtil.checkNull(L2Map.get("PRE_TREE_ID")).trim();
				String L2TreeItemID = StringUtil.checkNull(L2Map.get("TREE_ID")).trim();
				String L2TreeName =  StringUtil.checkNull(L2Map.get("TREE_NM")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " "); 
				String L2MDK = StringUtil.checkNull(L2Map.get("MDK")).trim();
				String L2MDC = StringUtil.checkNull(L2Map.get("MDC")).trim();
				String L2MDA = StringUtil.checkNull(L2Map.get("MDA")).trim();
				String L2MDE = StringUtil.checkNull(L2Map.get("MDE")).trim();
				String L2MDI = StringUtil.checkNull(L2Map.get("MDI")).trim();
				String L2MBCOK = StringUtil.checkNull(L2Map.get("MBCOK")).trim();
				String L2MBCOC = StringUtil.checkNull(L2Map.get("MBCOC")).trim();
				String GWTPL2 = StringUtil.checkNull(L2Map.get("GWTP")).trim();
				String L2MDKItemID = StringUtil.checkNull(L2Map.get("MDKItemID")).trim();
				String L2MDCItemID = StringUtil.checkNull(L2Map.get("MDCItemID")).trim();
				String L2MDAItemID = StringUtil.checkNull(L2Map.get("MDAItemID")).trim();
				String L2MDEItemID = StringUtil.checkNull(L2Map.get("MDEItemID")).trim();
				String L2MDIItemID = StringUtil.checkNull(L2Map.get("MDIItemID")).trim();
				String L2MBCOKItemID = StringUtil.checkNull(L2Map.get("MBCOKItemID")).trim();
				String L2MDMBCOCItemID = StringUtil.checkNull(L2Map.get("MBCOCItemID")).trim();
				if(L2PreTreeItemID.equals(L1TreeItemID)){
					resultRow += "<row id='" + L2PreTreeItemID +"."+ rowIndex2 + "' open='1'>";	
					rowIndex2++;
					resultRow += "		<cell image='img_process.png'>" + L2TreeName + CELL_CLOSE;
					resultRow += CELL_OPEN + L2PreTreeItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2TreeItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDK + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDC + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDA + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDE + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDI + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MBCOK + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MBCOC + CELL_CLOSE;
					resultRow += CELL_OPEN + GWTPL2 + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDKItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDCItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDAItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDEItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDIItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MBCOKItemID + CELL_CLOSE;
					resultRow += CELL_OPEN + L2MDMBCOCItemID + CELL_CLOSE;
					int rowIndex3 = 0;
					for (int l = 0; l < L3List.size(); l++) {
						Map L3Map = (HashMap) L3List.get(l);
									
						String L3ClassCode = StringUtil.checkNull(L3Map.get("Level")).trim();
						String L3PreTreeItemID = StringUtil.checkNull(L3Map.get("PRE_TREE_ID")).trim();
						String L3TreeItemID = StringUtil.checkNull(L3Map.get("TREE_ID")).trim();
						String L3TreeName =  StringUtil.checkNull(L3Map.get("TREE_NM")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " "); 
						String L3MDK = StringUtil.checkNull(L3Map.get("MDK")).trim();
						String L3MDC = StringUtil.checkNull(L3Map.get("MDC")).trim();
						String L3MDA = StringUtil.checkNull(L3Map.get("MDA")).trim();
						String L3MDE = StringUtil.checkNull(L3Map.get("MDE")).trim();
						String L3MDI = StringUtil.checkNull(L3Map.get("MDI")).trim();
						String L3MBCOK = StringUtil.checkNull(L3Map.get("MBCOK")).trim();
						String L3MBCOC = StringUtil.checkNull(L3Map.get("MBCOC")).trim();
						String GWTPL3 = StringUtil.checkNull(L3Map.get("GWTP")).trim();
						String L3MDKItemID = StringUtil.checkNull(L3Map.get("MDKItemID")).trim();
						String L3MDCItemID = StringUtil.checkNull(L3Map.get("MDCItemID")).trim();
						String L3MDAItemID = StringUtil.checkNull(L3Map.get("MDAItemID")).trim();
						String L3MDEItemID = StringUtil.checkNull(L3Map.get("MDEItemID")).trim();
						String L3MBCOKItemID = StringUtil.checkNull(L3Map.get("MBCOKItemID")).trim();
						String L3MBCOCItemID = StringUtil.checkNull(L3Map.get("MBCOCItemID")).trim();
						String L3MDIItemID = StringUtil.checkNull(L3Map.get("MDIItemID")).trim();
						if(L3PreTreeItemID.equals(L2TreeItemID)){							
							resultRow += "<row id='" + L3PreTreeItemID +"."+ rowIndex3 + "' open='1'>";	
							rowIndex3++;
							resultRow += "		<cell image='img_process.png'>" + L3TreeName + CELL_CLOSE;
							resultRow += CELL_OPEN + L3PreTreeItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3TreeItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDK + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDC + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDA + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDE + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDI + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MBCOK + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MBCOC + CELL_CLOSE;
							resultRow += CELL_OPEN + GWTPL3 + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDKItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDCItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDAItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDEItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MDIItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MBCOKItemID + CELL_CLOSE;
							resultRow += CELL_OPEN + L3MBCOCItemID + CELL_CLOSE;
							int rowIndex4 = 0;
							
							for (int m = 0; m < L4List.size(); m++) {
								Map L4Map = (HashMap) L4List.get(m);
											
								String L4ClassCode = StringUtil.checkNull(L4Map.get("Level")).trim();
								String L4PreTreeItemID = StringUtil.checkNull(L4Map.get("PRE_TREE_ID")).trim();
								String L4TreeItemID = StringUtil.checkNull(L4Map.get("TREE_ID")).trim();
								String L4TreeName =  StringUtil.checkNull(L4Map.get("TREE_NM")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " "); 
								String MDK = StringUtil.checkNull(L4Map.get("MDK")).trim();
								String MDC = StringUtil.checkNull(L4Map.get("MDC")).trim();
								String MDA = StringUtil.checkNull(L4Map.get("MDA")).trim();
								String MDE = StringUtil.checkNull(L4Map.get("MDE")).trim();
								String MDI = StringUtil.checkNull(L4Map.get("MDI")).trim();
								String MBCOK = StringUtil.checkNull(L4Map.get("MBCOK")).trim();
								String MBCOC = StringUtil.checkNull(L4Map.get("MBCOC")).trim();
								String GWTPL4 = StringUtil.checkNull(L4Map.get("GWTP")).trim();
								String L4MDKItemID = StringUtil.checkNull(L4Map.get("MDKItemID")).trim();
								String L4MDCItemID = StringUtil.checkNull(L4Map.get("MDCItemID")).trim();
								String L4MDAItemID = StringUtil.checkNull(L4Map.get("MDAItemID")).trim();
								String L4MDEItemID = StringUtil.checkNull(L4Map.get("MDEItemID")).trim();
								String L4MDIItemID = StringUtil.checkNull(L4Map.get("MDIItemID")).trim();
								String L4MBCOKItemID = StringUtil.checkNull(L4Map.get("MBCOKItemID")).trim();
								String L4MBCOCItemID = StringUtil.checkNull(L4Map.get("MBCOCItemID")).trim();
								if(L4PreTreeItemID.equals(L3TreeItemID)){	
									resultRow += "<row id='" + L4PreTreeItemID +"."+ rowIndex4 + "'>";	
									rowIndex4++;
									resultRow += "		<cell image='img_process.png'>" + L4TreeName + CELL_CLOSE;
									resultRow += CELL_OPEN + L4PreTreeItemID + CELL_CLOSE;
									resultRow += CELL_OPEN + L4TreeItemID + CELL_CLOSE;
								
									if(MDK.equals("O")){
										resultRow += CELL_OPEN_CUSOR + MDK + CELL_CLOSE;
									}else{
										resultRow += CELL_OPEN + MDK + CELL_CLOSE; }
									if(MDC.equals("O")){
										resultRow += CELL_OPEN_CUSOR + MDC + CELL_CLOSE;
									}else{
										resultRow += CELL_OPEN + MDC + CELL_CLOSE; }
									if(MDA.equals("O")){
										resultRow += CELL_OPEN_CUSOR + MDA + CELL_CLOSE;
									}else{
										resultRow += CELL_OPEN + MDA + CELL_CLOSE; }
									if(MDE.equals("O")){
										resultRow += CELL_OPEN_CUSOR + MDE + CELL_CLOSE;
									}else{
										resultRow += CELL_OPEN + MDE + CELL_CLOSE; }
									
									if(MDI.equals("O")){
										resultRow += CELL_OPEN_CUSOR + MDI + CELL_CLOSE;
									}else{
										resultRow += CELL_OPEN + MDI + CELL_CLOSE; }
									
									if(MBCOK.equals("O")){
										resultRow += CELL_OPEN_CUSOR + MBCOK + CELL_CLOSE;
									}else{
										resultRow += CELL_OPEN + MBCOK + CELL_CLOSE; }
									if(MBCOC.equals("O")){
										resultRow += CELL_OPEN_CUSOR + MBCOC + CELL_CLOSE;
									}else{
										resultRow += CELL_OPEN + MBCOC + CELL_CLOSE; }
									resultRow += CELL_OPEN + GWTPL4 + CELL_CLOSE;
									resultRow += CELL_OPEN + L4MDKItemID + CELL_CLOSE;
									resultRow += CELL_OPEN + L4MDCItemID + CELL_CLOSE;
									resultRow += CELL_OPEN + L4MDAItemID + CELL_CLOSE;
									resultRow += CELL_OPEN + L4MDEItemID + CELL_CLOSE;
									resultRow += CELL_OPEN + L4MDIItemID + CELL_CLOSE;
									resultRow += CELL_OPEN + L4MBCOKItemID + CELL_CLOSE;
									resultRow += CELL_OPEN + L4MBCOCItemID + CELL_CLOSE;
									resultRow += ROW_CLOSE;
								}
							}resultRow += ROW_CLOSE; //L3	
						}
					}resultRow += ROW_CLOSE; //L2	
				} 
			}resultRow += ROW_CLOSE; //L1
		}

		result += resultRow;
		result += "</rows>";
		System.out.println(result);
		return result.replace("&", "&amp;"); // 특수 문자 제거
	}
		
	@RequestMapping(value="/processExportMD.do")
	public String processExportMD(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url = "";
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
			String filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath", commandMap));
			commandMap.put("filePath", filePath);
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("delItemsYN", delItemsYN);
			commandMap.put("onlyMap", "N");
			commandMap.put("attrTypeCode", "AT00029");
	
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			commandMap.put("itemAuthorID", selectedItemMap.get("AuthorID"));
			commandMap.put("itemProjectID", selectedItemMap.get("ProjectID"));
			System.out.println("commandMap : "+commandMap);
			
			/* 첨부 문서 취득 */
			setMap.put("DocumentID", request.getParameter("s_itemID"));
			setMap.put("DocCategory", "ITM");
			List L2AttachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);			
			List modelList = new ArrayList();
			List totalList = new ArrayList();
			
			List allTotalList = new ArrayList();
			Map allTotalMap = new HashMap();
			Map titleItemMap = new HashMap();
			String e2eModelId = "";
			Map e2eModelMap = new HashMap();
			List subTreeItemIDList = new ArrayList();
			String selectedItemPath = "";
			Map e2eAttrMap = new HashMap();
			Map e2eAttrNameMap = new HashMap();
			Map e2eAttrHtmlMap = new HashMap();
			List e2eDimResultList = new ArrayList();
			
			Map piAttrMap = new HashMap();
			Map piAttrNameMap = new HashMap();
			Map piAttrHtmlMap = new HashMap();
			
			String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			List rptAllocClassList = commonService.selectList("report_SQL.getRptAllocatedClass", commandMap);
			Map e2eClassMap = new HashMap();
			Map piClassMap = new HashMap();
			
			List L2SubItemInfoList = new ArrayList();
				
			if(rptAllocClassList.size() > 0){			
				for (int i = 0; rptAllocClassList.size() > i; i++) {
					Map map = (Map) rptAllocClassList.get(i);
					if(reportCode.equals("RP00008")){ // get E2E allocation Report List	
						e2eClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
					}else if(reportCode.equals("RP00031")){ // get PI allocation Report List	
						piClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
					}
				}
			}
			
			if (e2eClassMap.containsKey(classCode)) {// E2E				
				/* Model 정보 취득 */
				setMap.put("ModelTypeCode", "MT003");
				e2eModelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
				
				/** 선택된 Item의 Path취득 (Id + Name) */
				selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
				
				commandMap.put("ItemID", request.getParameter("s_itemID"));
				commandMap.put("DefaultLang", defaultLang);
				List attrList = new ArrayList();
				if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
					/** 선택된 E2E Item의 기본정보의 속성 내용을 취득 */
					reportActionController.getE2EAttrInfo(commandMap, e2eAttrMap, e2eAttrNameMap, e2eAttrHtmlMap);
					
					/** 선택된 E2E Item의 Dimension 정보 취득 */
					reportActionController.getE2EDimInfo(setMap, e2eDimResultList);
				}
				
				if (null == e2eModelMap) {
					url = AJAXPAGE;
				} else {
					reportActionController.setModelMap(e2eModelMap, request); // TODO
					e2eModelId = StringUtil.checkNull(e2eModelMap.get("ModelID"));
					List parentList = reportActionController.getE2EModelList(e2eModelId, "SB00001", "");
					
					for (int p = 0; parentList.size() > p ; p++) {
						titleItemMap = new HashMap();
						Map parentMap = (Map) parentList.get(p);
						
						/* 프로세스 요약의 타이틀 설정 */
						setMap.put("s_itemID", parentMap.get("MyItemID"));
						titleItemMap = commonService.select("report_SQL.getItemInfo", setMap);
						/* 해당 아이템에 정의 되어 있는 모델 리스트 취득 */
						List childList = reportActionController.getE2EModelList(e2eModelId, "SB00004", StringUtil.checkNull(parentMap.get("ElementID")));
						
						if (childList.size() > 0) { // 해당 아이템에 정의 되어 있는 모델이 존재 할 경우
							allTotalMap = new HashMap();
							totalList = new ArrayList();
							reportActionController.setTotalList(totalList, childList, setMap, request, commandMap, defaultLang, languageId);
							allTotalMap.put("titleItemMap", titleItemMap);
							allTotalMap.put("totalList", totalList);
							allTotalList.add(allTotalMap);
						}
					}
				}
				
				/** 목차 리스트 취득 */
				if (totalList.size() > 0) {
					subTreeItemIDList = reportActionController.getE2EContents(allTotalList);
				}
			}else if(piClassMap.containsKey(classCode)){ // PI WordReport 
				/** 선택된 Item의 Path취득 (Id + Name) */
				//selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
				selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");;
				
				commandMap.put("ItemID", request.getParameter("s_itemID"));
				commandMap.put("DefaultLang", defaultLang);
				List attrList = new ArrayList();
				if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
					/** 선택된 PI Item의 기본정보의 속성 내용을 취득 */
					reportActionController.getPIAttrInfo(commandMap, piAttrMap, piAttrNameMap, piAttrHtmlMap);
					
					/** 선택된 PI Item의 연관프로세스 취득 */
					setMap.put("languageID", request.getParameter("languageID"));
					List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					
					allTotalMap = new HashMap();
					totalList = new ArrayList();
					reportActionController.setTotalList(totalList, relItemList, setMap, request, commandMap, defaultLang, languageId);
					titleItemMap = selectedItemMap;
					allTotalMap.put("titleItemMap", titleItemMap);
					allTotalMap.put("totalList", totalList);
					allTotalList.add(allTotalMap);
					
				}
				
				/** 목차 리스트 취득 */
				if (totalList.size() > 0) {
					subTreeItemIDList = reportActionController.getE2EContents(allTotalList);
				}
			} else {
				if ("CL01005".equals(classCode)) {
					Map subProcessMap = new HashMap();
					subProcessMap.put("MyItemID", request.getParameter("s_itemID"));
					modelList.add(subProcessMap);
					selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");
				} else {
					setMap.put("ClassCode", "subProcess");
					
					// Dimension tree인경우
					String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
					commandMap.put("ArcCode", arcCode);
					commandMap.put("SelectMenuId", arcCode);
					//Map arcFilterDimInfoMap =  commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
					String outPutItems = "";
					/*if (null != arcFilterDimInfoMap) {
						outPutItems = getArcDimTreeIDs(commandMap);
						setMap.put("outPutItems", outPutItems);
					}*/
						
					modelList = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
					setMap.remove("ClassCode");
					
					/** 목차 리스트 취득 */
					subTreeItemIDList = reportActionController.getChildItemList(commonService, request.getParameter("s_itemID"), classCode, languageId, outPutItems, delItemsYN);
					
					/** 선택된 Item의 Path취득 (Id + Name) */
					selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
					
					/** 선택된 Item의 SubProcess Item취득(L2) */
					setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
					setMap.put("CategoryCode", "ST1");
					setMap.put("languageID", languageId);
					setMap.put("toItemClassCode", "CL01004");	
					
					L2SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				}
				// 해당 아이템의 하위 항목의 서브프로세스 수 만큼 word report 작성
				reportActionController.setTotalList(totalList, modelList, setMap, request, commandMap, defaultLang, languageId);
				titleItemMap = selectedItemMap;
				allTotalMap.put("titleItemMap", titleItemMap);
				allTotalMap.put("totalList", totalList);
				allTotalMap.put("L2AttachFileList", L2AttachFileList);
				allTotalList.add(allTotalMap);
			}

			model.put("allTotalList", allTotalList);
			model.put("e2eModelMap", e2eModelMap); // E2E report 출력인 경우
			model.put("e2eItemInfo", selectedItemMap); // E2E report 출력인 경우
			model.put("e2eAttrMap", e2eAttrMap); // E2E report 출력인 경우
			model.put("e2eAttrNameMap", e2eAttrNameMap); // E2E report 출력인 경우
			model.put("e2eAttrHtmlMap", e2eAttrHtmlMap); // E2E report 출력인 경우
			model.put("e2eDimResultList", e2eDimResultList); // E2E report 출력인 경우
			
			model.put("piItemInfo", selectedItemMap); // PI report 출력인 경우
			model.put("piAttrMap", piAttrMap); // PI report 출력인 경우
			model.put("piAttrNameMap", piAttrNameMap); // PI report 출력인 경우
			model.put("piAttrHtmlMap", piAttrHtmlMap); // PI report 출력인 경우
			model.put("reportCode", reportCode);
			model.put("onlyMap", commandMap.get("onlyMap"));
			model.put("paperSize", request.getParameter("paperSize"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			
			model.put("attrName", getLabel(request, commonService, "AT"));	/*attrName Setting*/	
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("subTreeItemIDList", subTreeItemIDList);
			model.put("selectedItemPath", selectedItemPath);
			String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
			String selectedIdentifier = StringUtil.checkNull(selectedItemMap.get("Identifier")).replace("&#xa;", "");
			
			model.put("ItemNameOfFileNm", itemNameofFileNm);
			model.put("selectedIdentifier", selectedIdentifier);
			allTotalMap.put("L2SubItemInfoList", L2SubItemInfoList);
			
			setMap.put("languageID", languageId);
			String extLangCode = StringUtil.checkNull(commonService.selectString("common_SQL.getLanguageExtCode",setMap));
			commandMap.put("extLangCode", extLangCode);
			model.put("selectedItemID", StringUtil.checkNull(selectedItemMap.get("ItemID")));
			
			HashMap resultMap = (HashMap)makeWordExportMD(commandMap,model);
			if(!resultMap.isEmpty()){
				String insertFileResult = reportActionController.insertFile( resultMap, model, commandMap);
			}
		
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	/*MANDO wordReport*/ 
	public static Map makeWordExportMD(HashMap commandMap, ModelMap model) {
		HashMap returnMap = new HashMap();
		try{
			String LogoImgUrl = "";
			String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
			String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
			String defaultFont = String.valueOf(model.get("defaultFont"));
		 	
			License license = new License();
			license.setLicense(logoPath + "Aspose.Words.lic");
			
			Document doc = new Document();
			DocumentBuilder builder = new DocumentBuilder(doc);	
			
			Map menu = (Map)model.get("menu");
			Map attrName = (Map)model.get("attrName");
		 	Map setMap = (HashMap)model.get("setMap");
		 	List allTotalList = (List)model.get("allTotalList");
		 	
		 	String onlyMap = String.valueOf(model.get("onlyMap"));
		 	String paperSize = String.valueOf(model.get("paperSize"));
		 	String itemNameOfFileNm = String.valueOf(model.get("ItemNameOfFileNm"));
		 	
		 	Map e2eModelMap = (Map)model.get("e2eModelMap");
		 	Map e2eItemInfo = (Map)model.get("e2eItemInfo");
		 	Map e2eAttrMap = (Map)model.get("e2eAttrMap");
		 	Map e2eAttrNameMap = (Map)model.get("e2eAttrNameMap");
		 	Map e2eAttrHtmlMap = (Map)model.get("e2eAttrHtmlMap");
		 	
		 	Map piItemInfo = (Map)model.get("piItemInfo");
		 	Map piAttrMap = (Map)model.get("piAttrMap");
		 	Map piAttrNameMap = (Map)model.get("piAttrNameMap");
		 	Map piAttrHtmlMap = (Map)model.get("piAttrHtmlMap");
		 	
		 	List e2eDimResultList = (List)model.get("e2eDimResultList");
		 	
		 	List subTreeItemIDList = (List)model.get("subTreeItemIDList");
		 	String selectedItemPath = String.valueOf(model.get("selectedItemPath"));
		 	String reportCode = String.valueOf(model.get("reportCode"));
		 	double titleCellWidth = 60.0;
		 	double contentCellWidth3 = 90.0;
			double contentCellWidth = 160.0;
			double mergeCellWidth = 380.0;
			double totalCellWidth = 440.0;
			String value = "";
			String name = "";
			String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 10pt;\">";
			String ulStyle = "<ul style=\"padding-left:30px;\">";
			String olStyle = "<ol style=\"padding-left:30px;\">";
		//==================================================================================================
			Section currentSection = builder.getCurrentSection();
		    PageSetup pageSetup = currentSection.getPageSetup();
		    
		    // page 여백 설정
			builder.getPageSetup().setRightMargin(30);
			builder.getPageSetup().setLeftMargin(30);
			builder.getPageSetup().setBottomMargin(30);
			builder.getPageSetup().setTopMargin(30);
			
			// PaperSize 설정
			if ("1".equals(paperSize)) {
				builder.getPageSetup().setPaperSize(PaperSize.A4);
			} else if ("2".equals(paperSize)) {
				builder.getPageSetup().setPaperSize(PaperSize.A3);
			}
		//==================================================================================================

		//=========================================================================
		// TODO : FOOTER
			currentSection = builder.getCurrentSection();
		    pageSetup = currentSection.getPageSetup();
		    
		    pageSetup.setDifferentFirstPageHeaderFooter(false);
		    pageSetup.setFooterDistance(25);
		    builder.moveToHeaderFooter(HeaderFooterType.FOOTER_PRIMARY);
		    
		    builder.startTable();
		    builder.getCellFormat().getBorders().setLineWidth(0.0);
		    builder.getFont().setName(defaultFont);
		    builder.getFont().setColor(Color.BLACK);
		    builder.getFont().setSize(10);
		    
		 	// 1.footer : Line
		 	builder.getParagraphFormat().setSpaceBefore(7);
		    builder.insertHtml("<hr size=5 color='silver'/>");
		 	// 2.footer : logo
		    builder.insertCell();
		    builder.getCellFormat().setWidth(150.0);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		    String imageFileName = logoPath + "logo.png";
		    //builder.insertImage(imageFileName, 125, 25);
		 	// 3.footer : current page / total page 
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.insertCell();
		    builder.getCellFormat().setWidth(150.0);
		    // Set first cell to 1/3 of the page width.
		    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
		    // Insert page numbering text here.
		    // It uses PAGE and NUMPAGES fields to auto calculate current page number and total number of pages.
		    builder.insertField("PAGE", "");
		    builder.write(" / ");
		    builder.insertField("NUMPAGES", "");
		    
		 	// 4.footer : current page / total page 
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.insertCell();
		    builder.getCellFormat().setWidth(150.0);
		    builder.write("BPR Team");
		    
		    builder.endTable().setAllowAutoFit(false);
		        
		    builder.moveToDocumentEnd();
		//=========================================================================
			
			builder = new DocumentBuilder(doc);
			
			//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			for (int totalCnt = 0;allTotalList.size() > totalCnt ; totalCnt++ ) {
				Map allTotalMap = (Map)allTotalList.get(totalCnt);
				Map titleItemMap = new HashMap();
				List totalList = (List)allTotalMap.get("totalList");
				if (!e2eModelMap.isEmpty()) {
					titleItemMap = e2eItemInfo;
				}else{
					titleItemMap = (Map)allTotalMap.get("titleItemMap");
				}
				
				//==================================================================================================
				/* 표지 */
				//if (totalList.size() > 0) { 
					currentSection = builder.getCurrentSection();
				    pageSetup = currentSection.getPageSetup();
				    pageSetup.setDifferentFirstPageHeaderFooter(true);
				   // pageSetup.setD
				 	// 표지 START
				 	builder.startTable();
				 	builder.getCellFormat().getBorders().setLineWidth(0.0);
				 	
				 	// 1.image
				 	builder.insertCell();
		    		builder.getCellFormat().setWidth(300.0);
				 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	builder.insertHtml("<br>");
		    	//	builder.insertImage(imageFileName, 180, 36);
		    		builder.insertHtml("<br>");
		    		builder.endRow();
		    		
		    		// 2.프로세스 정의서
		    		builder.insertCell();
		    		builder.getFont().setColor(Color.BLACK);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
				    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				    builder.getFont().setSize(60);
				    builder.insertHtml("<br>");
				    builder.getFont().setSize(36);
				    if (!e2eModelMap.isEmpty()) {
				    	builder.writeln("E2E Process report");
				    }else if(reportCode.equals("RP00031")){
				    	builder.writeln("PI Task report");
				    } else {
				    	builder.writeln("Business process manual");
				    }
					builder.endRow();
					
					// 3.선택한 L2 프로세스 정보
		    		builder.insertCell();
		    		builder.getFont().setColor(Color.BLACK);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
				    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				    builder.getFont().setSize(26);
				    builder.getFont().setUnderline(0);
					builder.writeln("["+selectedItemPath+"]");
					builder.insertHtml("<br>");
		    		builder.insertHtml("<br>");
		    		builder.insertHtml("<br>");
					builder.endRow();
		    		
		    		// 4.선택한 L2 프로세스 정보 테이블
		    		///////////////////////////////////////////////////////////////////////////////////////
		    		builder.insertCell();
		    		builder.getCellFormat().setWidth(30); // 테이블 앞 여백 설정
		    		
		    		builder.insertCell();
		    		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		    		builder.getCellFormat().setWidth(240);
		    		
		    		builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(247, 247, 247));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(11);
					builder.getFont().setUnderline(0);
					builder.getFont().setBold(false);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(70);
					builder.write(String.valueOf(menu.get("LN00060"))); // 작성자

					builder.insertCell();
					builder.getCellFormat().setWidth(100);
					builder.write(String.valueOf(menu.get("LN00018"))); // 관리조직

					builder.insertCell();
					builder.getCellFormat().setWidth(70);
					builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
					
					builder.endRow();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(70);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));				
					builder.insertCell();
				   	builder.getCellFormat().setWidth(100);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write("BPR Team");
					builder.insertCell();
				   	builder.getCellFormat().setWidth(70);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("LastUpdated")));	
					builder.endRow();
					builder.endTable().setAlignment(TabAlignment.CENTER);
					builder.endRow();
					
					builder.endTable().setAllowAutoFit(false);
		    		///////////////////////////////////////////////////////////////////////////////////////
		    		// 표지 END
				    builder.insertBreak(BreakType.PAGE_BREAK);
		    		if (subTreeItemIDList.size() > 0) { 
		    			// content START	
						builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(14);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					    builder.insertHtml("<br>");
						builder.writeln("- Content -"); // content
						builder.insertHtml("<br>");
						
					    builder.getFont().setSize(11);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					    
						for (int lowlankCnt = 0;subTreeItemIDList.size() > lowlankCnt ; lowlankCnt++) {
							Map lowLankItemIdMap = (Map) subTreeItemIDList.get(lowlankCnt);
							
							String l2Item = StringUtil.checkNull(lowLankItemIdMap.get("l2Item"));
							List l3l4ItemIdList = (List) lowLankItemIdMap.get("l3l4ItemIdList");
							
							if (!l2Item.isEmpty()) {
								builder.writeln("\t" + l2Item);
							}
							
							for (int l3l4Cnt = 0;l3l4ItemIdList.size() > l3l4Cnt ; l3l4Cnt++) {
								Map l3l4ItemIdMap = (Map) l3l4ItemIdList.get(l3l4Cnt);
								String l3Item = StringUtil.checkNull(l3l4ItemIdMap.get("l3Item"));
								List l4ItemList = (List) l3l4ItemIdMap.get("l4ItemList");
								
								if (!l3Item.isEmpty()) {
									builder.writeln("\t\t" + l3Item);
								}
								for (int l4Cnt = 0;l4ItemList.size() > l4Cnt ; l4Cnt++) {
									builder.writeln("\t\t\t" + l4ItemList.get(l4Cnt).toString());
								}
							}
						}
		    		}
					// content END
					
					/* E2E : E2E기본정보 및 E2E모델맵 표시*/
					if (!e2eModelMap.isEmpty()) {
						builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
						//==================================================================================================
						// 머릿말 : START
						currentSection = builder.getCurrentSection();
					    pageSetup = currentSection.getPageSetup();
					    pageSetup.setDifferentFirstPageHeaderFooter(false);
					    pageSetup.setHeaderDistance(25);
					    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
					    
						builder.startTable();
						builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(25.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
						builder.insertCell();
						builder.getCellFormat().getBorders().setColor(Color.WHITE);
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getFont().setName(defaultFont);
					    builder.getFont().setBold(true);
					    builder.getFont().setColor(Color.BLUE);
					    builder.getFont().setSize(14);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					   	name = StringUtil.checkNullToBlank(e2eItemInfo.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
					   	name = name.replace("&#10;", " ");
					   	name = name.replace("&#xa;", "");
					   	name = name.replace("&nbsp;", " ");
					    builder.write("E2E Scenario : " + StringUtil.checkNullToBlank(e2eItemInfo.get("Identifier")) + " "+ name);
					   
					    builder.getFont().setName(defaultFont);
					    builder.getFont().setColor(Color.LIGHT_GRAY);
					    builder.getFont().setSize(12);
					    
					    builder.insertCell();
						builder.getCellFormat().getBorders().setColor(Color.WHITE);
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
						String path = String.valueOf(e2eItemInfo.get("Path"));
						if (path.equals("/")) {
							path = "";
						}
					    builder.write(path); 
					    builder.endRow();	
					    builder.endTable().setAllowAutoFit(false);	
					    
					    // 타이틀과 내용 사이 간격
					    builder.insertHtml("<hr size=4 color='silver'/>");
					    
					 	// 머릿말 : END
					 	builder.moveToDocumentEnd();
					  	//==================================================================================================
					  	//==================================================================================================
					  	// E2E 기본정보 표시
						builder.startTable();
			 	 		
			 	 	    builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(10);
			 	 		
			 	 		// Make the header row.
			 	 		builder.getRowFormat().clearFormatting();
			 	 		builder.getCellFormat().clearFormatting();
			 	 		builder.getRowFormat().setHeight(150.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 	 	// 1.ROW : 개요
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00003")));  // 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String e2eAT00003 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+e2eAT00003.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 		// 2.ROW 
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00020")));  //  Module
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 	
			 	 		String e2eAT00020 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+e2eAT00020.replace("/upload", logoPath)+"</span>");
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00072")));  // 
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String e2eAT00072 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+e2eAT00072.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 3.ROW
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00004"))); // 담당자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("Name"))); // 담당자 명용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00018")));  // Due date
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 	
			 	 		String e2eAT00018 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+e2eAT00018.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 4.ROW
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00013"))); // 생성일
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("CreateDT"))); // 생성일 : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00070")));  // 수정일
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("LastUpdated"))); // 수정일 : 내용
			 	 		builder.endRow();
			 	 		//==================================================================================================
			 	 		
			 	 		// 5.ROW
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00006")));  // 비고
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 	
			 	 		String e2eAT00006 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+e2eAT00006.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 6.ROW (Dimension 정보 만큼 행 표시)
			 	 		for(int j=0; j<e2eDimResultList.size(); j++){
			 	 			Map dimResultMap = (Map) e2eDimResultList.get(j);
				 	 		
			 	 			builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(dimResultMap.get("dimTypeName")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(mergeCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(dimResultMap.get("dimValueNames")));
				 	 		//==================================================================================================	
			 	 			builder.endRow();
			 	 		}
			 	 		
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		builder.writeln();
					  	
					  	
					  	//==================================================================================================
						//==================================================================================================
					 	//프로세스 맵
					 	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 	 	builder.startTable();
				 	    
				 	 	builder.insertCell();
				 	 	builder.getRowFormat().clearFormatting();
				 		builder.getCellFormat().clearFormatting();
				 		builder.getRowFormat().setHeight(20.0);
				 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
				 	 	builder.getCellFormat().setWidth(totalCellWidth);
				 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 	
				 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
				 		String imgPath = modelImgPath+e2eModelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
				 		int width = Integer.parseInt(String.valueOf(e2eModelMap.get("Width")));
				 		int height = Integer.parseInt(String.valueOf(e2eModelMap.get("Height")));
				 		System.out.println("프로세스맵 imgPath="+imgPath);
				 		try{
				 			builder.insertHtml("<br>");
				 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
				 			builder.insertHtml("<br>");
				 		} catch(Exception ex){}
				 		
				 		builder.endTable().setAllowAutoFit(false);
					}
			 		//==================================================================================================
					// E2E 기본정보 END
				
					// PI 과제기본정보 */
					if(reportCode.equals("RP00031")){ 
						builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
						//==================================================================================================
						// 머릿말 : START
						currentSection = builder.getCurrentSection();
					    pageSetup = currentSection.getPageSetup();
					    pageSetup.setDifferentFirstPageHeaderFooter(false);
					    pageSetup.setHeaderDistance(25);
					    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
					    
						builder.startTable();
						builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(25.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
						builder.insertCell();
						builder.getCellFormat().getBorders().setColor(Color.WHITE);
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getFont().setName(defaultFont);
					    builder.getFont().setBold(true);
					    builder.getFont().setColor(Color.BLUE);
					    builder.getFont().setSize(14);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					   	name = StringUtil.checkNullToBlank(piItemInfo.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
					   	name = name.replace("&#10;", " ");
					   	name = name.replace("&#xa;", "");
					   	name = name.replace("&nbsp;", " ");
					    builder.write("PI 과제 : " + StringUtil.checkNullToBlank(piItemInfo.get("Identifier")) + " "+ name);
					   
					    builder.getFont().setName(defaultFont);
					    builder.getFont().setColor(Color.LIGHT_GRAY);
					    builder.getFont().setSize(12);
					    
					    builder.insertCell();
						builder.getCellFormat().getBorders().setColor(Color.WHITE);
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
						String path = String.valueOf(piItemInfo.get("Path"));
						if (path.equals("/")) {
							path = "";
						}
					    builder.write(path); 
					    builder.endRow();	
					    builder.endTable().setAllowAutoFit(false);	
					    
					    // 타이틀과 내용 사이 간격
					    builder.insertHtml("<hr size=4 color='silver'/>");
					    
					 	// 머릿말 : END
					 	builder.moveToDocumentEnd();
					  	//==================================================================================================
					  	//==================================================================================================
					  	// PI과제 기본정보 표시
						builder.startTable();
			 	 		
			 	 	    builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(10);
			 	 		
			 	 		// Make the header row.
			 	 		builder.getRowFormat().clearFormatting();
			 	 		builder.getCellFormat().clearFormatting();
			 	 		builder.getRowFormat().setHeight(150.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 	 	// 1.ROW : 개요
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00003")));  // PI 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 	
			 	 		String piAT00003 = StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+piAT00003.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 2.ROW : 비고
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00006")));  // PI 비고
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 					 	 		
			 	 		String piAT00006 = StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+piAT00006.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 		// 3.ROW
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00060"))); // 작성자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("Name"))); // 작성자 : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00022")));  // PI 담당자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 	
			 	 		String piAT00022 = StringUtil.checkNullToBlank(piAttrMap.get("AT00022")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+piAT00022.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 4.ROW
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00013"))); // 생성일
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("CreateDT"))); // 생성일 : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00070")));  // 수정일
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("LastUpdated"))); // 수정일 : 내용
			 	 		builder.endRow();
			 	 		//==================================================================================================
			 	 				
			 	 		// 5.ROW : 오너조직, Owner
		 	 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00033"))); // 오너조직
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String piAT00033 = StringUtil.checkNullToBlank(piAttrMap.get("AT00033")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+piAT00033.replace("/upload", logoPath)+"</span>");
				 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00012"))); // 오너
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	
			 	 		String piAT00012 = StringUtil.checkNullToBlank(piAttrMap.get("AT00012")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+piAT00012.replace("/upload", logoPath)+"</span>");
			 	 		builder.endRow();
			 	 		//==================================================================================================
			 	 		
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		builder.writeln();
					  	
					  	
					}			
				//} 
				// PI 과제기본정보 END */
					
				//==================================================================================================
				if (totalList.size() > 0) { 
			 	for (int index = 0; totalList.size() > index ; index++) {
			 		
			 		if (totalList.size() != 1) {
			 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 		}
			 		
			 		Map totalMap = (Map)totalList.get(index);
			 		
			 		List prcList = (List)totalMap.get("prcList");
			 		Map rowPrcData =  (HashMap) prcList.get(0); 
			 		List activityList = (List)totalMap.get("activityList");
			 		List elementList = (List)totalMap.get("elementList");
			 		List cnitemList = (List)totalMap.get("cnitemList");
			 		List dimResultList = (List)totalMap.get("dimResultList");
			 		List ruleSetList = (List)totalMap.get("ruleSetList");
			 		List kpiList = (List)totalMap.get("kpiList");
			 		List requirementList = (List)totalMap.get("requirementList");
			 		List attachFileList = (List)totalMap.get("attachFileList");
			 		List toCheckList = (List)totalMap.get("toCheckList");
			 		
			 		List companyRuleList = (List)totalMap.get("companyRuleList");
			 		List guideLineProcList = (List)totalMap.get("guideLineProcList");
			 		List standardFormList = (List)totalMap.get("standardFormList");
			 		
			 		Map attrMap = (Map)totalMap.get("attrMap");
			 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
			 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
			 		Map modelMap = (Map)totalMap.get("modelMap");
			 		Map attrRsNameMap = (Map)totalMap.get("attrRsNameMap");
			 		Map attrRsHtmlMap = (Map)totalMap.get("attrRsHtmlMap");
			 		Map attrToCheckNameMap = (Map)totalMap.get("attrToCheckNameMap");
			 		Map attrToCheckHtmlMap = (Map)totalMap.get("attrToCheckHtmlMap");
			 		
			 		Map attrCompanyRuleNameMap = (Map)totalMap.get("attrCompanyRuleNameMap");
			 		Map attrCompanyRuleHtmlMap = (Map)totalMap.get("attrCompanyRuleHtmlMap");
			 		Map attrGuideProcNameMap = (Map)totalMap.get("attrGuideProcNameMap");
			 		Map attrGuideProcHtmlMap = (Map)totalMap.get("attrGuideProcHtmlMap");
			 		Map attrguideSystemNameMap = (Map)totalMap.get("attrGuideSystemNameMap");
			 		Map attrguideSystemHtmlMap = (Map)totalMap.get("attrGuideSystemHtmlMap");
			 		
			 		currentSection = builder.getCurrentSection();
			 	    pageSetup = currentSection.getPageSetup();
			 	    
			 	    pageSetup.setDifferentFirstPageHeaderFooter(false);
			 	    pageSetup.setHeaderDistance(25);
			 	    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
			 	    
			 	    //==================================================================================================
			 		// NEW 머릿글 : START
			 	    builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					
					builder.getRowFormat().setHeight(26.0);
					// builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					// Some special features for the header row.
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(14);
					builder.getFont().setUnderline(0);
					builder.getFont().setBold(true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(25);
					builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
					//builder.insertCell();
		    		builder.insertImage(imageFileName, 125, 25);

					builder.insertCell();
					builder.getCellFormat().setWidth(75);
					name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			 	   	name = name.replace("&#10;", " ");
			 	   	name = name.replace("&#xa;", "");
			 	    name = name.replace("&nbsp;", " ");
			 	    builder.write("Business Process Manual"); 
			 	  //  builder.write(rowPrcData.get("Identifier") + " "+ name);  	
					
					builder.endRow();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setUnderline(0);
					builder.getFont().setBold(false);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
				    builder.insertCell(); 	
				    builder.getCellFormat().setWidth(25);
					builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(30);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(rowPrcData.get("Identifier") + " "+ name);  
		    		
					builder.insertCell();
				   	builder.getCellFormat().setWidth(45);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Path")));
					builder.endRow();
					
					builder.endTable().setAllowAutoFit(false);
					 // 타이틀과 내용 사이 간격
			 	    builder.insertHtml("<hr size=4 color='silver'/>");
			 	 	// 머릿말 : END
			 	 	builder.moveToDocumentEnd();
			 	  	//==================================================================================================
			 	  		
			 		// 아이템 속성 		
			 		if ("N".equals(onlyMap)) {
			 			// 프로세스 기본 정보 Title
			 	 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
						builder.writeln("1. " + String.valueOf(menu.get("LN00198")));
						
			 			builder.startTable();
			 	 		
			 	 	    builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(10);
			 	 		
			 	 		// Make the header row.
			 	 		builder.getRowFormat().clearFormatting();
			 	 		builder.getCellFormat().clearFormatting();
			 	 		builder.getRowFormat().setHeight(200.0);
			 	 		//builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 	 	// 1.ROW : 개요
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrName.get("AT00029")));  // 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

			 	 		String AT00029 = StringUtil.checkNullToBlank(attrMap.get("AT00029")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+AT00029.replace("/upload", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		/*/ 2.ROW : 클래스,SystemType
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(30.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00016")));  // 계층
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowPrcData.get("ClassName"))); // 계층 : 내용
			 	 		//==================================================================================================	
			 	 		builder.endRow(); */
			 	 		
			 	 		/*/ 3.ROW : KPI
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(30.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00043")));  // KPI
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00043"))); //    
			 	 		//==================================================================================================	
			 	 		builder.endRow(); */
			 	 		
			 	 		//3.ROW : 선행/후행
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
					 	 		
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00053")));  // 선행
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00053"))); // 선행 : 내용
			 	 		
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00054")));  // 후행
			 	 					 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00054"))); // 후행 : 내용
			 	 		
			 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		//4.ROW : 담당/책임
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
					 	 		
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00010")));  // 담당
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00010"))); // 담당 : 내용
			 	 		
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00022")));  // 책임
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00022"))); // 책임 : 내용
			 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		//5.ROW : 주기/참조자료
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
					 	 		
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00009")));  // 주기
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00009"))); // 주기 : 내용
			 	 		
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00064")));  // 참조자료
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00064"))); // 참조자료 : 내용
			 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 6.ROW : Input,Output
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
			 	 		//builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경	
			 	 		
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00015")));  // Input
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00015"))); // Input : 내용
			 	 		
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00016")));  // Output
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00016"))); // Output : 내용
			 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 			 	 		
			 	 		
			 	 	    //7.ROW : 담당자, 수정일
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경	 	
			 	 		
		 	 			builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00004")));  // 담당자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold (false);
			 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 담당자 명
			 	 		
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(30.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("LastUpdated"))); // 수정일 : 내용
			 	 		//==================================================================================================	
			 	 		builder.endRow(); 	 		
			 	 	
			 	 				
			 	 		// 8.ROW (Dimension 정보 만큼 행 표시)
			 	 		for(int j=0; j<dimResultList.size(); j++){
			 	 			Map dimResultMap = (Map) dimResultList.get(j);
				 	 		
			 	 			builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(dimResultMap.get("dimTypeName")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(mergeCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(dimResultMap.get("dimValueNames")));
				 	 		//==================================================================================================	
			 	 			builder.endRow();
			 	 		}
			 	 		
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		builder.writeln();
			 	 		
			 	 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 	 		
			 	 		// 2. 선/후행 프로세스
			 	 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
						builder.writeln("2. " + String.valueOf(menu.get("LN00178"))+"Process");
						
				 		if (elementList.size() > 0) {
				 			Map cnProcessData = new HashMap();
					 		
							builder.startTable();			
							builder.getRowFormat().clearFormatting();
							builder.getCellFormat().clearFormatting();
							
							// Make the header row.
							builder.insertCell();
							builder.getRowFormat().setHeight(20.0);
							builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
							
							// Some special features for the header row.
							builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							builder.getFont().setSize(10);
							builder.getFont().setBold (true);
							builder.getFont().setColor(Color.BLACK);
							builder.getFont().setName(defaultFont);
							
							builder.getCellFormat().setWidth(10);
							builder.write(String.valueOf(menu.get("LN00024"))); // No

							builder.insertCell();
							builder.getCellFormat().setWidth(20);
							builder.write(String.valueOf(menu.get("LN00042"))); // 구분

							builder.insertCell();
							builder.getCellFormat().setWidth(35);
							builder.write(String.valueOf(menu.get("LN00106"))); // ID

							builder.insertCell();
							builder.getCellFormat().setWidth(65);
							builder.write(String.valueOf(menu.get("LN00028"))); // 명칭

							builder.insertCell();
							builder.getCellFormat().setWidth(120);
							builder.write(String.valueOf(menu.get("LN00035"))); // 개요
							builder.endRow();	
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
							
							for(int j=0; j<elementList.size(); j++){
								cnProcessData = (HashMap) elementList.get(j);
							    
						    	builder.insertCell();
							    if( j==0){
							    	// Reset font formatting.
							    	builder.getFont().setBold(false);
							    }
							    
								String itemName = StringUtil.checkNullToBlank(cnProcessData.get("Name")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
								itemName = itemName.replace("&#10;", " ");
								itemName = itemName.replace("&#xa;", "");
								itemName = itemName.replace("&nbsp;", " ");
								String processInfo = StringUtil.checkNullToBlank(cnProcessData.get("Description")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
								processInfo = processInfo.replace("&#10;", " ");
								processInfo = processInfo.replace("&#xa;", "");
								processInfo = processInfo.replace("&nbsp;", " ");
								processInfo = fontFamilyHtml + processInfo.replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle)+"</span>";
																
								builder.getCellFormat().setWidth(10);
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							   	builder.write(StringUtil.checkNullToBlank(cnProcessData.get("RNUM")));	
								
							   	builder.insertCell();
							   	builder.getCellFormat().setWidth(20);
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.write(StringUtil.checkNullToBlank(cnProcessData.get("KBN")));				
								builder.insertCell();
							   	builder.getCellFormat().setWidth(35);
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.write(StringUtil.checkNullToBlank(cnProcessData.get("ID")));				
								builder.insertCell();
							   	builder.getCellFormat().setWidth(65);
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								builder.write(itemName);				
								builder.insertCell();
								builder.getCellFormat().setWidth(120);
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								builder.insertHtml(processInfo);
								
								builder.endRow();
							}	
							
							builder.endTable().setAllowAutoFit(false);	
				 		}
				 							
						//if (null != modelMap) {
				 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 		//}
				 		
				 		// 7.업무처리 절차 Title
				 		if (null == modelMap) {
				 			builder.insertHtml("<br>");
				 		}
				 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
						builder.writeln("3. " + String.valueOf(menu.get("LN00197")));
						
			 	 		if (null != modelMap) {
			 	 		//==================================================================================================
			 		 		//프로세스 맵
			 		 	 	builder.startTable();
			 		 	 	builder.insertCell();
			 		 	 	builder.getRowFormat().clearFormatting();
			 		 		builder.getCellFormat().clearFormatting();
			 		 		builder.getRowFormat().setHeight(20.0);
			 		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
			 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 		 	 	
			 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
			 		 		String imgPath = modelImgPath+modelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
			 		 		int width = Integer.parseInt(String.valueOf(modelMap.get("Width")));
			 		 		int height = Integer.parseInt(String.valueOf(modelMap.get("Height")));
			 		 		System.out.println("프로세스맵 imgPath="+imgPath);
			 		 		try{
			 		 			builder.insertHtml("<br>");
			 		 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
			 		 			builder.insertHtml("<br>");
			 		 		} catch(Exception ex){}
			 		 		
			 		 		
			 		 		builder.endTable().setAllowAutoFit(false);
			 		 		
			 		 		//==================================================================================================
			 	 		}
				 		
				 		// 액티비티리스트
				 		// Build the other cells.
				 		// 액티비티리스트나 연관항목중 한건이라도 존재하면 새로운 페이지를 추가한다
				 		//if (activityList.size() > 0 || cnitemList.size() > 0) {
				 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 		//}
						
				 		// 7.액티비티 리스트 Title
				 		if (activityList.size() == 0) {
				 			builder.insertHtml("<br>");
				 		}
				 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
						builder.writeln("4. " + String.valueOf(menu.get("LN00151")));
						builder.insertHtml("<br>");
						if (activityList.size() > 0) {
							Map rowActData = new HashMap();	
							for(int j=0; j<activityList.size(); j++){
								rowActData = (HashMap) activityList.get(j);
								
								builder.getFont().setColor(Color.DARK_GRAY);
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
							    
							    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
							    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
							    itemName = itemName.replace("&#10;", " ");
								itemName = itemName.replace("&#xa;", "");
								itemName = itemName.replace("&nbsp;", " ");
							    builder.writeln(identifier+" "+itemName); //명칭
							    
							    builder.insertHtml("<br>");
								builder.writeln("["+StringUtil.checkNullToBlank(attrName.get("AT00030"))+"]");// "[Description]"
								builder.getFont().setBold(false);
				 	 		
				 	 			String AT00030 = StringUtil.checkNullToBlank(rowActData.get("AT00030")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
						 		builder.insertHtml(fontFamilyHtml+AT00030.replace("/upload", logoPath)+"</span>");
								builder.insertHtml("<br>");
								
								builder.getFont().setBold(true);
								//=====상세수행내역=========
								builder.insertHtml("<br>");
								builder.writeln("["+StringUtil.checkNullToBlank(attrName.get("AT00062"))+"]");// GuideLine [수행내역세부사항]
								builder.getFont().setBold(false);
				 	 			String AT00062 = StringUtil.checkNullToBlank(rowActData.get("AT00062")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
						 		builder.insertHtml(fontFamilyHtml+AT00062.replace("/upload", logoPath)+"</span>");
								builder.insertHtml("<br>");		
										
								builder.getFont().setBold(true);
								builder.writeln("["+StringUtil.checkNullToBlank(attrName.get("AT00037"))+"]"); // [System Type]
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00037"))); // SystemType
								builder.insertHtml("<br>");
								
								builder.getFont().setBold(true);
								builder.writeln("["+StringUtil.checkNullToBlank(attrName.get("AT00014"))+"]"); // [화면코드]
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00014"))); // 화면코드
								builder.insertHtml("<br>");
								
							}
							
							//==================================================================================================
					 		// 5.사규 		
							builder.insertHtml("<br>");
				 	 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln("5. Company Rule");
							if (companyRuleList.size() > 0 && companyRuleList != null) {	
								Map rowCnData = new HashMap();
								
								builder.startTable();
								builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();		
								builder.getFont().setSize(10);
								//builder.getFont().setBold (true);
								builder.getFont().setColor(Color.BLACK);
								builder.getFont().setName(defaultFont);
								// Make the header row.
								builder.insertCell();
								builder.getRowFormat().setHeight(20.0);
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
								
								// Some special features for the header row.
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								builder.getFont().setSize(10);
								builder.getFont().setBold (true);
								builder.getFont().setColor(Color.BLACK);
								builder.getFont().setName(defaultFont);
								
								builder.getCellFormat().setWidth(30);
								builder.write(String.valueOf(menu.get("LN00024"))); // No

								builder.insertCell();
								builder.getCellFormat().setWidth(titleCellWidth);
								builder.write(String.valueOf(menu.get("LN00106"))); // ID

								builder.insertCell();
								builder.getCellFormat().setWidth(contentCellWidth);
								builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
								builder.endRow();
								int idx = 1;
								for(int j=0; j<companyRuleList.size(); j++){						
									rowCnData = (HashMap) companyRuleList.get(j);	 						
															 	 		
						 	 		builder.insertCell();
									builder.getRowFormat().setHeight(30.0);
									builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
									
						 	 		builder.getCellFormat().setWidth(30);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
							 		builder.write(StringUtil.checkNullToBlank(idx)); // 
							 		
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setWidth(titleCellWidth);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
							 		builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemIdentifier"))); // ID : 내용
						 	 		
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setWidth(contentCellWidth);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
					 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemName"))); // 명칭 : 내용
						 	 		//==================================================================================================	
						 	 		builder.endRow();
					 	 								
									builder.endTable().setAllowAutoFit(false);	
									
									idx++;
								}	
								builder.insertHtml("<br>");
								
							} 
							//==================================================================================================
							
							//==================================================================================================
					 		// 6.업무지침
							builder.insertHtml("<br>");
				 	 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln("6. Business Guideline");
							if (guideLineProcList.size() > 0 && guideLineProcList != null) {								
						 		
								Map rowCnData = new HashMap();
								
								builder.getFont().setSize(10);
								//builder.getFont().setBold (true);
								builder.getFont().setColor(Color.BLACK);
								builder.getFont().setName(defaultFont);
								builder.startTable();
								builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								
								// Make the header row.
								builder.insertCell();
								builder.getRowFormat().setHeight(20.0);
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
								
								// Some special features for the header row.
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								builder.getFont().setSize(10);
								builder.getFont().setBold (true);
								builder.getFont().setColor(Color.BLACK);
								builder.getFont().setName(defaultFont);
								
								builder.getCellFormat().setWidth(30);
								builder.write(String.valueOf(menu.get("LN00024"))); // No
	
								builder.insertCell();
								builder.getCellFormat().setWidth(titleCellWidth);
								builder.write(String.valueOf(menu.get("LN00106"))); // ID
	
								builder.insertCell();
								builder.getCellFormat().setWidth(contentCellWidth);
								builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
								builder.endRow();							
														
								int idx = 1;
								for(int j=0; j<guideLineProcList.size(); j++){						
									rowCnData = (HashMap) guideLineProcList.get(j);			 		
									 	 		
						 	 		builder.insertCell();
									builder.getRowFormat().setHeight(30.0);
									builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
									
						 	 		builder.getCellFormat().setWidth(30);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
							 		builder.write(StringUtil.checkNullToBlank(idx)); // 
							 		
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setWidth(titleCellWidth);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
							 		builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemIdentifier"))); // ID : 내용
						 	 		
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setWidth(contentCellWidth);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
					 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemName"))); // 명칭 : 내용
						 	 		//==================================================================================================	
						 	 		builder.endRow();						 	 		
					 	 								
									builder.endTable().setAllowAutoFit(false);	
																		
									idx++;
								}	
								builder.insertHtml("<br>");
								
							} 
							//==================================================================================================
							
							//==================================================================================================
					 		// 7.서식
							builder.insertHtml("<br>");
				 	 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln("7. Standard Form");
							if (standardFormList.size() > 0 && standardFormList != null) {							
						 		
								Map rowCnData = new HashMap();
								
								builder.getFont().setSize(10);
								//builder.getFont().setBold (true);
								builder.getFont().setColor(Color.BLACK);
								builder.getFont().setName(defaultFont);
								builder.startTable();
								builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								
								// Make the header row.
								builder.insertCell();
								builder.getRowFormat().setHeight(20.0);
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
								
								// Some special features for the header row.
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								builder.getFont().setSize(10);
								builder.getFont().setBold (true);
								builder.getFont().setColor(Color.BLACK);
								builder.getFont().setName(defaultFont);
								
								builder.getCellFormat().setWidth(30);
								builder.write(String.valueOf(menu.get("LN00024"))); // No

								builder.insertCell();
								builder.getCellFormat().setWidth(titleCellWidth);
								builder.write(String.valueOf(menu.get("LN00106"))); // ID

								builder.insertCell();
								builder.getCellFormat().setWidth(contentCellWidth);
								builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
								builder.endRow();	
								int idx = 1;
								for(int j=0; j<standardFormList.size(); j++){						
									rowCnData = (HashMap) standardFormList.get(j);	
															 	 		
						 	 		builder.insertCell();
									builder.getRowFormat().setHeight(30.0);
									builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
									
						 	 		builder.getCellFormat().setWidth(30);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
							 		builder.write(StringUtil.checkNullToBlank(idx)); // 
							 		
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setWidth(titleCellWidth);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
							 		builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemIdentifier"))); // ID : 내용
						 	 		
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setWidth(contentCellWidth);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getFont().setBold(false);
					 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemName"))); // 명칭 : 내용
						 	 		//==================================================================================================	
						 	 		builder.endRow();						 	 		
					 	 								
									builder.endTable().setAllowAutoFit(false);	
									
									
									idx++;
								}	
								builder.insertHtml("<br>");
								
							} 
							//==================================================================================================
						}
						//==================================================================================================
						
				 	} else {
				 		if (null != modelMap) {
				 	 		//==================================================================================================
			 		 		//프로세스 맵
			 		 	 	builder.startTable();
			 		 	    
			 		 	 	builder.insertCell();
			 		 	 	builder.getRowFormat().clearFormatting();
			 		 		builder.getCellFormat().clearFormatting();
			 		 		builder.getRowFormat().setHeight(20.0);
			 		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
			 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 		 	 	
			 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
			 		 		String imgPath = modelImgPath+modelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
			 		 		int width = Integer.parseInt(String.valueOf(modelMap.get("Width")));
			 		 		int height = Integer.parseInt(String.valueOf(modelMap.get("Height")));
			 		 		System.out.println("프로세스맵 imgPath="+imgPath);
			 		 		try{
			 		 			builder.insertHtml("<br>");
			 		 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
			 		 			builder.insertHtml("<br>");
			 		 		} catch(Exception ex){}
			 		 		
			 		 		
			 		 		builder.endTable().setAllowAutoFit(false);
			 		 		
			 		 		//==================================================================================================
			 	 		}
				 	}
		 	 	
			 	} 
			}
			}
			
			//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String extLangCode = StringUtil.checkNull(commandMap.get("extLangCode"));
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));			
			String identifier = StringUtil.checkNull(model.get("selectedIdentifier"));
			String filePath = StringUtil.checkNull(commandMap.get("filePath"));			
			if(filePath.equals("") || filePath == null){
				filePath = "E://OLMFILE//document/item//manual//";
			}
			File dirFile = new File(filePath); if(!dirFile.exists()){dirFile.mkdirs();} 

			String sysFileName = DateUtil.getCurrentTime() + ".docx";
		    String fileName = identifier+"_"+itemNameOfFileNm+"(Process manual)"+"_"+extLangCode+".docx";
		
		    String downFile = filePath + sysFileName;	
			doc.save(downFile);
			
			returnMap.put("sysFileName", sysFileName);		
			returnMap.put("fileName", fileName);		
			returnMap.put("filePath", filePath);		
			returnMap.put("fltpCode", "FLTP004");
			returnMap.put("fileMgt", "ITM");
			
		} catch(Exception e){
			System.out.println(e.toString());
			
		}	
		return returnMap;		
	}	

	// 만도 결재 함수
	/**
	 * 만도 그룹웨어 결재 페이지 호출 하여 진행
	 * 호출 시 상신 문서에 들어갈 본문 내용은 HTML형식으로 만듬
	 * 만도 그룹웨어에 전송할 JSON 데이터 만들고 해당 데이터를 전송
	 * 상신 완료 / 반려 / 승인 시 zmd_UpdateWFReturnValue 함수 호출
	 */
	@RequestMapping("/zmd_WFDocMgt.do")
	public String zmd_WFDocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "";
		Map setMap = new HashMap();

		try {
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String wfStep = StringUtil.checkNull(request.getParameter("wfStep"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
			String wfStepInfo = StringUtil.checkNull(request.getParameter("wfStep"), "WF001"); // TODO
			String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"),"CS");
			String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
			String isPop = StringUtil.checkNull(request.getParameter("isPop"),"N");
			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"));
			String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"));
			String preWfInstanceID = StringUtil.checkNull(request.getParameter("preWfInstanceID"));
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));
			String actionType = StringUtil.checkNull(request.getParameter("actionType"),"create");
			String backFunction = "wfInstanceList.do";
			String backMessage = "";
			String callbackData = "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
			
			if("".equals(projectID)) {
				setMap.put("s_itemID", changeSetID);
				projectID = commonService.selectString("cs_SQL.getProjectIDForCSID", setMap);
			}
			
			Map labelMap = getLabel(request, commonService);

			String newWFInstanceID = "";
			
			String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
			String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
			int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();	
			String initLen = "%0" + (13-OLM_SERVER_NAME_LENGTH) + "d";
			
			int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
			int maxcode = maxWFInstanceID2 + 1;
			newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);

			if(!"".equals(preWfInstanceID))
				wfInstanceID = preWfInstanceID;
			
			// 합의 /승인 단계 리스트 취득				
			setMap.put("LanguageID", commandMap.get("languageID"));
			setMap.put("WFID", wfStepInfo);
			setMap.put("TypeCode", wfStepInfo);
			setMap.put("ProjectID", projectID);
			
			List wfStepList = commonService.selectList("wf_SQL.getWfStepList", setMap);
			
			String wfDescription = commonService.selectString("wf_SQL.getWFDescription", setMap);
			String MandatoryGRID = commonService.selectString("wf_SQL.getMandatoryGRID", setMap);

			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("projectID", projectID);
			String ProjectName = commonService.selectString("project_SQL.getProjectName", setMap);
			
			setMap.put("WFStepIDs", "'AREQ','APRV','AGR'");
			
			List wfStepInstList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
			int wfStepInstListSize = 0;
			if(wfStepInstList != null && !wfStepInstList.isEmpty())
				wfStepInstListSize = wfStepInstList.size();
			
			model.put("wfStepInstListSize", wfStepInstListSize);
			
			String wfStepInstInfo = "";
			String wfStepInstREFInfo = "";
			String wfStepInstAGRInfo = "";
			
			String wfStepMemberIDs = "";
			String wfStepRoleTypes = "";
			
			Map wfStepInstInfoMap = new HashMap();
			Map getPJTMap = new HashMap();
			
			setMap.put("dimTypeID", "100001");
			List regionList = commonService.selectList("dim_SQL.getDimValueNameList", setMap);
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", projectID);
			setMap.put("wfInstanceID", wfInstanceID);
			
			Map getMap = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
			model.put("getMap", getMap);

			if(getMap != null && !getMap.isEmpty())
				setMap.put("DocCategory", getMap.get("DocCategory"));

			if(isMulti.equals("N")) {
				setMap.put("ProjectID", projectID);
				setMap.put("ChangeSetID", changeSetID);		
				getPJTMap = commonService.select("wf_SQL.getChangeSetInfoWF", setMap);
				backFunction = "itemChangeInfo.do";
				callbackData = "&changeSetID="+request.getParameter("ChangeSetID")+"&screenMode=edit&StatusCode=MOD&isAuthorUser=&LanguageID="+commandMap.get("sessionCurrLangType");
				backMessage = StringUtil.checkNull(labelMap.get("LN00206"));
			}				
			else {
				setMap.put("wfInstanceID", wfInstanceID);
				getPJTMap = commonService.select("wf_SQL.getWFInstTXT", setMap);
				
			}
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", projectID);
			model.put("getPJTMap", getPJTMap);
			
			Map setData = new HashMap();
			if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV")){
				setData.put("ProjectID",projectID);
				setData.put("Status","CNG");
				commonService.update("project_SQL.updateProject",setData);
			}else if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV2")){
				setData.put("ProjectID",projectID);
				setData.put("Status","QA");
				commonService.update("project_SQL.updateProject",setData);
			}
			
			//최초 상신이거나 미 상신 완료인 경우에 해당 로직 동작
			if(actionType.equals("create") || (actionType.equals("view") && getMap != null && !getMap.isEmpty() && "0".equals(getMap.get("Status")))) {
				
				if(!"".equals(changeSetID)) {
					
					String sbj = StringUtil.checkNull(getPJTMap.get("Identifier")) + " " + StringUtil.checkNull(getPJTMap.get("ItemName"));
					
					commandMap.put("wfDocType",wfDocType);
					commandMap.put("documentID",changeSetID);
					
					if("".equals(wfInstanceID)) {
						commandMap.put("subject",sbj);
						commandMap.put("projectID",projectID);
						
						zmd_SubmitMDWfInst(request, commandMap, model);
					}
					String returnURL = GlobalVal.OLM_SERVER_URL + "zmd_UpdateWFReturnValue.do";		

					commandMap.put("returnURL",returnURL);
					
					if(wfInstanceID == null || "".equals(wfInstanceID) || !"".equals(preWfInstanceID)) 
						commandMap.put("docKey",newWFInstanceID);	
					else 
						commandMap.put("docKey",wfInstanceID);
					
					commandMap.put("subject","");
			    	model = zmd_createHanmaruHTML(request,commandMap,model);
			    	url = "/custom/mando/zmd_goHanmaruWorkflow";
				}
				else {
					
					if(wfDocType.equals("CS")) {
						url = GlobalVal.CS_APPROVAL_PATH;
					}
					else if(wfDocType.equals("CSR")) {
						url = GlobalVal.CSR_APPROVAL_PATH;
					}	
					
					model.put("regionList", regionList);
					model.put("getPJTMap", getPJTMap);
					
					model.put("wfStep", wfStep);
					model.put("wfDocType", wfDocType);
					
					model.put("menu", labelMap);  // Label Setting 
					model.put("isNew", isNew);
					model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
					model.put("ProjectID", projectID);
					model.put("wfDocType", wfDocType);
					model.put("backFunction", backFunction);
					model.put("backMessage", backMessage);
					model.put("callbackData", callbackData);
					model.put("categoryCnt", categoryCnt);
					model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
					model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
					model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
					model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
					model.put("preWfInstanceID", preWfInstanceID);
					model.put("ProjectName", ProjectName);
					model.put("wfDocumentIDs", wfDocumentIDs);
					model.put("wfInstanceID", wfInstanceID);
					model.put("isMulti", isMulti);
					model.put("isPop", isPop);
					model.put("changeSetID", changeSetID);
					model.put("wfDescription", wfDescription);
					model.put("MandatoryGRID", MandatoryGRID);
					
					if(wfInstanceID == null || "".equals(wfInstanceID) || !"".equals(preWfInstanceID)) 
						model.put("newWFInstanceID", newWFInstanceID);		
					else 
						model.put("newWFInstanceID", wfInstanceID);
					

					model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
					model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
					
				}
					
			}
			//문서 조회 시 해당 로직 동작
			else if(actionType.equals("view") && getMap != null && !getMap.isEmpty() && !"0".equals(getMap.get("Status"))) {
				url = "/wf/approvalViewPop";

				List attachFileList = new ArrayList();
				List wfInstList = new ArrayList();
				
				setMap.put("wfInstanceID", wfInstanceID);
				String returnedValue = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfReturnedValue", setMap));
				
				model.put("data", returnedValue);
				model.put("parameter","docId");
				model.put("url", "https://ep.hlcompany.com/Workflow/Page/Link.aspx");
			}


		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	// 결재 상신 SUBMIT
	@RequestMapping(value = "/zmd_SubmitMDWfInst.do")
	public String zmd_SubmitMDWfInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
				HashMap setData = new HashMap();
				HashMap setMap = new HashMap();
				HashMap inserWFInstTxtData = new HashMap();
				HashMap insertWFStepData = new HashMap();
				HashMap insertWFStepRefData = new HashMap();
				HashMap insertWFInstData = new HashMap();
				HashMap updateData = new HashMap();
				HashMap updateCRData = new HashMap();
				
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String srID = StringUtil.checkNull(commandMap.get("srID"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"),"CS");
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String Status = StringUtil.checkNull(commandMap.get("Status"));
				String description = StringUtil.checkNull(commandMap.get("description"));
				String subject = StringUtil.checkNull(commandMap.get("subject"));
				String isMulti = StringUtil.checkNull(commandMap.get("isMulti"));
				String wfDocumentIDs = StringUtil.checkNull(commandMap.get("wfDocumentIDs"));
				String hanmaruParam = StringUtil.checkNull(commandMap.get("hanmaruParam"));
				Map menu = getLabel(request, commonService);
				
				setData.put("wfID", wfID);
				String newWFInstanceID = "";
				
				String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setData);
				String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
				int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();	
				String initLen = "%0" + (13-OLM_SERVER_NAME_LENGTH) + "d";
								
				int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
				int maxcode = maxWFInstanceID2 + 1;
				newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);
				
				insertWFInstData.put("WFInstanceID", newWFInstanceID);
				insertWFInstData.put("ProjectID", projectID);
				insertWFInstData.put("DocumentID", documentID);
				insertWFInstData.put("DocCategory", wfDocType);
				insertWFInstData.put("WFID", wfID);
				insertWFInstData.put("Creator", loginUser);
				insertWFInstData.put("LastUser", loginUser);
				insertWFInstData.put("Status", "-1"); // 상신 & before Hanmaru function call
				insertWFInstData.put("aprvOption", aprvOption);
				insertWFInstData.put("curSeq", "1");
				insertWFInstData.put("LastSigner", loginUser);
				
				commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);
				
				String maxId = "";

				int lastSeq = 1;
					
				insertWFStepData.put("Seq", "0");
				String status = null;
				maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
				insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1);
				insertWFStepData.put("ProjectID", projectID);
				
				status = "0"; 		
				insertWFStepData.put("Status", status);
				insertWFStepData.put("ActorID", loginUser);
				insertWFStepData.put("WFID", wfID);
				insertWFStepData.put("WFStepID", "AREQ");				
				
				if(wfInstanceID.isEmpty()){ insertWFStepData.put("WFInstanceID", newWFInstanceID); }
				commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
								
				inserWFInstTxtData.put("WFInstanceID",newWFInstanceID);
				inserWFInstTxtData.put("subject",subject);
				inserWFInstTxtData.put("subjectEN",subject);
				inserWFInstTxtData.put("description",description);
				inserWFInstTxtData.put("descriptionEN",description);
				inserWFInstTxtData.put("comment","");
				inserWFInstTxtData.put("actorID",loginUser);
				commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);	
				
				/* DocumentType에 따라 분기 처리 wfDocType 변수 이용 */
				
				updateData = new HashMap();
				setMap.put("srID", srID);
				setMap.put("aprvOption", aprvOption);
				setMap.put("projectID", projectID);
				if(Status.equals("CNG")){
					updateData.put("Status", "APRV2"); // 결재 중
											
					//Save PROC_LOG
					Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
					if(setProcMapRst.get("type").equals("FAILE")){
						String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
						System.out.println("Msg : "+Msg);
					}
				}else {
					updateData.put("Status", "APRV2"); // 결재 중
				}
				updateData.put("ProjectID", projectID);
				
			    updateCRData = new HashMap();	
				HashMap updateSR = new HashMap(); 

				updateCRData.put("Status", "APRV");
				updateCRData.put("lastUser", loginUser);
				updateCRData.put("userID", loginUser);

				if(wfDocType.equals("CS")) {
					
					if(isMulti.equals("Y")) {
						String ids[] = wfDocumentIDs.split(",");
						for(int i=0; i<ids.length; i++) {
							updateCRData.put("s_itemID", ids[i]);
							updateCRData.put("wfInstanceID",newWFInstanceID);
							commonService.update("cs_SQL.updateChangeSetForComDT", updateCRData);
						}
					}
					else {
						updateCRData.put("s_itemID", documentID);
						updateCRData.put("wfInstanceID",newWFInstanceID);
						commonService.update("cs_SQL.updateChangeSetForComDT", updateCRData);
					}
					
				}

				String returnURL = GlobalVal.OLM_SERVER_URL + "zmd_UpdateWFReturnValue.do";		
				
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00150")); // 상신 완료
			target.put(AJAX_SCRIPT,"parent.fnGoHanmaruPop('"+newWFInstanceID+"','"+returnURL+"');parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	

	@RequestMapping(value="/zmd_goHanmaruWorkflow.do")
	public String zmd_goHanmaruWorkflow(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {		
		try {
			Map setMap = new HashMap();

	    	model = zmd_createHanmaruHTML(request,cmmMap,model);
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		return nextUrl("/custom/mando/zmd_goHanmaruWorkflow");
	}
	
	//만도 결재 Callback 함수
	@RequestMapping(value = "/zmd_UpdateWFReturnValue.do")
	public String updateWFReturnValue(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID")); //OLM WF ID Value
				String ReturnedValue = StringUtil.checkNull(request.getParameter("hmrInstanceID")); // Hanmaru ID Value
				String Flag = StringUtil.checkNull(request.getParameter("status")); // Hanmaru Action Flag Draft = 기안, Approval = 결재, Complete = 완료, Reject = 거절
				String date = StringUtil.checkNull(request.getParameter("updateDate")); // Update Date
				String employeeNum = StringUtil.checkNull(request.getParameter("employeeNo")); // Update User
				String subject = StringUtil.checkNull(request.getParameter("subject")); // Update User
				String status = "";
				String url = "";
				String data = "";

				setMap.put("employeeNum", employeeNum);
				Map userMap = commonService.select("common_SQL.getLoginIDFromMember", setMap);					
				
				setMap.put("wfInstanceID", wfInstanceID);
				Map wfInfoMap = commonService.select("wf_SQL.getWFInstDoc", setMap);	

				setMap.put("loginID", userMap.get("LoginId"));	
				String wfID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFID", setMap),""); 
				String memberID = StringUtil.checkNull(commonService.selectString("user_SQL.member_id_select", setMap),""); 
				String projectID = StringUtil.checkNull(commonService.selectString("wf_SQL.getProjectID", setMap),""); 
				
				setMap.put("changeSetID", wfInfoMap.get("DocumentID"));
				String itemID = StringUtil.checkNull(commonService.selectString("cs_SQL.getItemIDForCSID", setMap),""); 

				
				if("N".equals(Flag)) { //상신
				
					setMap.put("itemID", itemID);
					String version = StringUtil.checkNull(commonService.selectString("cs_SQL.getItemReleaseVersion", setMap),""); 
					setMap.put("ItemID", itemID);
					Map itemDimInfo = commonService.select("dim_SQL.getDimListWithItemId", setMap);
					
					setMap.remove("itemID");
					setMap.remove("ItemID");
					setMap.remove("changeSetID");
					
					if("1.0".equals(version) || "1.01".equals(version)) {						
						setMap.put("Version", "2.0");	
					}
					
					setMap.put("status", "APRV");						
					setMap.put("wfInstanceID",wfInstanceID);
					commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
					

					setMap.put("subject", subject);	
					setMap.put("description", "");	
					setMap.put("loginID", memberID);	
					commonService.update("wf_SQL.updateWFInstTxT", setMap);
					
					setMap.put("Status", "1");
				}
				else if("E".equals(Flag)) { //완료
					// Update  WF Instance & CSR 		
					setMap.put("wfID","WF001");
					setMap.put("wfDocType",wfInfoMap.get("DocCategory"));
					
					String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setMap),""); 
				   
					if(postProcessing != "") {
					    status = "CLS";						
						if(postProcessing.split("\\?").length > 1) {
							String tmp[] = postProcessing.split("\\?");
							url = tmp[0];
						}
						else {
							url = postProcessing;						
						}
						
						if("updateCSStatusForWF.do".equals(url)) {
							commandMap.put("status","CLS");
							commandMap.put("wfInstanceID",wfInstanceID);
							CSActionController.updateCSStatusForWF(request,commandMap,model);
						}
						
					}					
					
					if(wfInfoMap.get("DocCategory").equals("CS")) {
						
						setMap.put("status", "CLS"); 	
						setMap.put("wfInstanceID", wfInstanceID);
						
						commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
					}

					setMap.put("Status", "2");
					
				}
				else if("D".equals(Flag)) { //반려
					
					setMap.put("wfID","WF001");
					setMap.put("wfDocType",wfInfoMap.get("DocCategory"));
					
					String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setMap),""); 
				   
					if(postProcessing != "") {				
						if(postProcessing.split("\\?").length > 1) {
							String tmp[] = postProcessing.split("\\?");
							url = tmp[0];
						}
						else {
							url = postProcessing;					
						}
						
						if("updateCSStatusForWF.do".equals(url)) {
							commandMap.put("status","WTR");
							commandMap.put("wfInstanceID",wfInstanceID);
							CSActionController.updateCSStatusForWF(request,commandMap,model);
						}
						
					}				
										
					setMap.put("Status", "3"); 	
				}			

				setMap.put("LastUser", memberID);	
				setMap.put("WFInstanceID", wfInstanceID);
				setMap.put("ReturnedValue", ReturnedValue);
				commonService.update("wf_SQL.updateWfInst", setMap);
				commonService.update("wf_SQL.updateWFStepInst", setMap); 	// Update TB_WF_STEP_INST
				

				response.setCharacterEncoding("UTF-8"); // 한글깨짐현상 방지
				PrintWriter out = response.getWriter();
			    out.append("true");
			    out.flush();
				
			
		} catch (Exception e) {
			System.out.println(e);
			response.setCharacterEncoding("UTF-8"); // 한글깨짐현상 방지
			PrintWriter out = response.getWriter();
		    out.append("false");
		    out.flush();
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	//결재 본문 내용 생성 함수
	public ModelMap zmd_createHanmaruHTML(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {		
		try {
			Map setMap = new HashMap();
	    	String url = GlobalVal.APPROVAL_SYS_URL;
			String subject = StringUtil.checkNull(cmmMap.get("subject"),"");
			String description = StringUtil.checkNull(cmmMap.get("description"),"");
			String returnURL = StringUtil.checkNull(cmmMap.get("returnURL"));
			String docKey = StringUtil.checkNull(cmmMap.get("docKey"));
			Map menu = getLabel(request, commonService);
	    	String param = "";

	    	setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("wfInstanceID", docKey);
			
			List csInstList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);	
			String startHTML = "<!doctype html><html><body>";
			String endHTML = "</body></html>";
			String openTable = "<table style='table-layout:fixed;border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>";
			String closeTable = "</table>";
			String openTh = " <th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>";
			String openTd ="<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>";
							
			String returnHTML = startHTML;
			returnHTML+= openTable;
			returnHTML+= "<colgroup><col width='10%'><col width='32%'><col width='8%'>";
			returnHTML+= "<col width='8%'></colgroup>";

			returnHTML+= " <tr> ";
			returnHTML+= openTh + StringUtil.checkNull(menu.get("LN00015")) + "</th> ";
			returnHTML+= openTh + "L4 Task Name</th> ";
			returnHTML+= openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> ";
			returnHTML+= openTh + StringUtil.checkNull(menu.get("LN00066")) + " Map </th> ";
			returnHTML+= " </tr>";
			
			for(int i=0; i<csInstList.size(); i++) {
				Map tempMap = (Map) csInstList.get(i);
				returnHTML+= " <tr style='height:26px;'> ";
				
				returnHTML+= openTd+StringUtil.checkNull(tempMap.get("Identifier"))+"</td>";
				returnHTML+= openTd+StringUtil.checkNull(tempMap.get("ItemName"))+"</td>";
				returnHTML+= openTd+StringUtil.checkNull(tempMap.get("AuthorName"))+"</td>";
				returnHTML+= openTd+"<a href='"+GlobalVal.OLM_SERVER_URL+"olmChangeSetLink.do?olmLoginid=guest&object=itm&linkType=id&keyID="+StringUtil.checkNull(tempMap.get("ItemID"))+"&linkID="+StringUtil.checkNull(tempMap.get("ChangeSetID"))+"&languageID="+StringUtil.checkNull(cmmMap.get("sessionCurrLangType"))+"' target='_blank'>"+ StringUtil.checkNull(menu.get("LN00313")) + "</a></td>";
				
				returnHTML+= " </tr>";
			}
			returnHTML+= closeTable+endHTML;
			
	    	param = "{\"Sabun\": \""+cmmMap.get("sessionEmployeeNm")+"\",";
	    	param += "\"CompCode\": \"00005\",";
	    	param += "\"HtmlBody\": \""+returnHTML+"\",";
	    	param += "\"DocKey\": \""+docKey+"\",";
	    	param += "\"returnURL\": \""+returnURL+"\"}";
	    	String paramEnc = zmd_wfEncrypt(param,"e0ed302ff5c045a3");
	    		    	
			model.put("url", url);
			model.put("paramEnc", paramEnc);
			model.put("param", param);
			model.put("callKey","hjUsME78lG33A1yxRbhmdQ==");
			model.put("menu", getLabel(request, commonService));
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		return model;
	}
	
	public static String zmd_wfDecrypt(String text, String key) throws Exception

    {

              Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");

              byte[] keyBytes= new byte[16];

              byte[] b= key.getBytes("UTF-8");

              int len= b.length;

              if (len > keyBytes.length) len = keyBytes.length;

              System.arraycopy(b, 0, keyBytes, 0, len);

              SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");

              IvParameterSpec ivSpec = new IvParameterSpec(keyBytes);

              cipher.init(Cipher.DECRYPT_MODE,keySpec,ivSpec);


              BASE64Decoder decoder = new BASE64Decoder();
              byte [] results = cipher.doFinal(decoder.decodeBuffer(text));
              return new String(results,"UTF-8");
    }



    public static String zmd_wfEncrypt(String text, String key) throws Exception

    {

              Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");

              byte[] keyBytes= new byte[16];

              byte[] b= key.getBytes("UTF-8");

              System.arraycopy(b, 0, keyBytes, 0, Math.min(b.length, keyBytes.length));

              SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");

              IvParameterSpec ivSpec = new IvParameterSpec(keyBytes);

              cipher.init(Cipher.ENCRYPT_MODE,keySpec,ivSpec);



              byte[] results = cipher.doFinal(text.getBytes("UTF-8"));

              BASE64Encoder encoder = new BASE64Encoder();

              return encoder.encode(results);

    } 
    
    /*
    public Map<String, String> selWfInfo(Map<String, String> reqMap) throws Exception {		
    	
		Map<String, String> wfInfo = new HashMap<String, String>();
		
		String wfInstanceID = reqMap.get("wfInstanceID");		
		String actionType = reqMap.get("actionType"); if(actionType.equals("")) actionType = "create";
		String documentNo = reqMap.get("documentNo");		
		
		String maxWFInstanceID = gqmsWfMapper.selMaxWFInstanceID(reqMap);
		String newWFInstanceID = "";
		
	    String GQMS_SERVER_NAME = "GQMS";
        int GQMS_SERVER_NAME_LENGTH = GQMS_SERVER_NAME.length();
        String initLen = "%0" + (13 - GQMS_SERVER_NAME_LENGTH) + "d";

        int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(GQMS_SERVER_NAME_LENGTH));
        int maxcode = maxWFInstanceID2 + 1;
        newWFInstanceID = GQMS_SERVER_NAME + String.format(initLen, new Object[] { Integer.valueOf(maxcode) });
                
        Map<String, String> wfInstInfo = gqmsWfMapper.selWfInstInfo(reqMap); 
		
        String sUserId = CommonUtil.getUserInfo().get("USER_ID");
        if ((actionType.equals("create")) || ((actionType.equals("view")) && (wfInstInfo != null) && (!wfInstInfo.isEmpty()) && ("-1".equals(wfInstInfo.get("Status"))))) {
     	  if ("".equals(wfInstanceID) || wfInstanceID == null) {
    		  Map<String, String> insWFInstData = new HashMap<String, String>();	
              insWFInstData.put("WFInstanceID", newWFInstanceID);
              insWFInstData.put("DocumentNo", documentNo);	    
              insWFInstData.put("Status", "-1");
              insWFInstData.put("LastSigner", sUserId);
    	      
              int result = gqmsWfMapper.insWfInst(insWFInstData);
    	      
           }
    	  String returnURL =  "http://172.20.120.220:8081/cm/admin/gqmsWf/gqmsUpdateWFReturnValue.do";
    	  reqMap.put("returnURL", returnURL);
    	  
    	  if (wfInstanceID == null || "".equals(wfInstanceID)) {
    		 wfInfo.put("dockey", newWFInstanceID);
    	  } else {
    		 wfInfo.put("dockey", wfInstanceID);
          }
    	  
    	  reqMap.put("dockey", wfInfo.get("dockey"));
    	  System.out.println("reqMap.get dockey :"+reqMap.get("dockey"));
    	  // 결재 본문 생성 및 암호화
    	  wfInfo = gqms_createHanmaruHTML(reqMap);
        } else if ((actionType.equals("view")) && (wfInstInfo != null) && (!wfInstInfo.isEmpty()) && (!"-1".equals(wfInstInfo.get("Status")))) {
        	 
             // setMap.put("wfInstanceID", wfInstanceID);String returnedValue = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWfReturnedValue", setMap));

             //map.put("data", returnedValue);
        	wfInfo.put("parameter", "docId");
        	wfInfo.put("url", "https://eptest2.hlcompany.com/Workflow/Page/LinkOpenGqms.aspx");
        }
        return wfInfo;
	}
	
	
	public Map<String, String> gqms_createHanmaruHTML(Map<String, String> reqMap) throws Exception{		
		try {
			//String url = "https://ep.hlcompany.com/Workflow/Page/LinkOpenGqms.aspx";
	    	String url = "https://eptest2.hlcompany.com/Workflow/Page/LinkOpenGqms.aspx"; // hanmaru Test 서버
			
			String title = "결재 제목 입니다. ";
			String description = "결재 본문 입니다. ";
			String returnURL = reqMap.get("returnURL");
			String dockey = reqMap.get("dockey");
			String doctype =  "temp1k";
			String email = "nerp3rd.hyoh@hlcompany.com";
			String saveurl = "http://172.20.120.220:8081/cm/admin/gqmsWf/gqmsWFReturnKey.do";
			String formtitle = "form title";
			String formcode = "form001";
	    	String param = "";

			String startHTML = "<!doctype html><html><body>";
			String endHTML = "</body></html>";
			String openTable = "<table style='table-layout:fixed;border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>";
			String closeTable = "</table>";
			String openTh = " <th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>";
			String openTd ="<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>";
							
			String returnHTML = startHTML;
			returnHTML+= openTable;
			returnHTML+= "<colgroup><col width='12%'><col width='88%'><col width='12%'><col width='88%'></colgroup>";

			returnHTML+= " <tr> ";
			returnHTML+= openTh + "제목 </th> ";
			returnHTML+= openTd + title + "</td>";			
			returnHTML+= " </tr>";
			
			returnHTML+= " <tr> ";
			returnHTML+= "<td colspan='2' style='height:400px;vertical-align:top;overflow:auto;border-left:1px solid #ddd;border-right:1px solid #ddd;border-bottom:1px solid #ddd;' class='tit last pdL10 pdR10'>";
			returnHTML+= "<br>" + description + "</td>";			
			returnHTML+= " </tr>";
			
			returnHTML+= closeTable+endHTML;
			
	    	param += "{\"compcode\": \"00005\",";	    	
	    	param += "\"email\": \""+email+"\",";
	    	//param += "\"htmlbody\": \""+returnHTML+"\",";	 
	    	param += "\"htmlbody\": \""+description+"\",";	 
	    	param += "\"description\": \"\",";
	    	param += "\"saveurl\": \""+saveurl+"\",";
	    	param += "\"returnURL\": \""+returnURL+"\",";
	    	param += "\"title\": \""+title+"\",";
	    	param += "\"formtitle\": \""+formtitle+"\",";
	    	param += "\"formcode\": \""+formcode+"\",";
	    	param += "\"dockey\": \""+dockey+"\",";
	    	param += "\"doctype\": \""+doctype+"\"}";
	    	
	    	System.out.println(" 결재 param  :"+param);
	    	String paramEnc = encrypt("c0a2da904b50811a6d64c20d",param);	
	    	String calkeyEnc = encrypt("c0a2da904b50811a6d64c20d","gqms");
	    	
	    	System.out.println(" calkeyEnc :"+calkeyEnc+", paramEnc:"+paramEnc);
			reqMap.put("url", url);
			reqMap.put("callkey",calkeyEnc);
			reqMap.put("paramEnc", paramEnc);
			reqMap.put("param", param);
				 
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	
		return reqMap;		
	}
	
	public static byte[] IV = { 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 };

    public static String encrypt(String encKey, String plainText) throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {

        byte[] keyData = encKey.getBytes("UTF-8");

        SecretKey secretKey = new SecretKeySpec(keyData, "AES");

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, new IvParameterSpec(IV));

        byte[] encData  = cipher.doFinal(plainText.getBytes("UTF-8"));

        return new String(Base64.encodeBase64(encData));
    }
		
	public static String decrypt(String encKey, String encText) throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {

        byte[] keyData = encKey.getBytes("UTF-8");

        SecretKey secretKey = new SecretKeySpec(keyData, "AES");

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, secretKey, new IvParameterSpec(IV));

        byte[] decData = Base64.decodeBase64(encText.getBytes());

        return new String(cipher.doFinal(decData), "UTF-8");
    }
    
    // http://localhost:8081/cm/admin/gqmsWf/gqmsUpdateWFReturnValue.do?doctype=temp1k&dockey=GQMS000000142&result=P
	// http://localhost:8081/cm/admin/gqmsWf/gqmsUpdateWFReturnValue.do?doctype=temp1k&dockey=GQMS000000142&returnkey=HAN000000142
	// Hanmaru -> GQMS 호출 API
	@RequestMapping(value = "/gqmsUpdateWFReturnValue.do")
	public String gqmsUpdateWFReturnValue(HttpServletRequest request, HttpServletResponse response)  throws Exception {
		
		String doctype = request.getParameter("doctype");
		String dockey = request.getParameter("dockey");
		String returnkey = request.getParameter("returnkey");
		
		String result = request.getParameter("result"); // P,S,R,D
		String empid = request.getParameter("empid"); 
		String email = request.getParameter("email"); 
		String appdate = request.getParameter("appdate"); 
		
		Map<String, String> reqMap = new HashMap<String, String>();
		
		String Status  = "";
		if(!returnkey.equals("") && returnkey != null) { // 임시저장
			
			reqMap.put("Status", "1");
			reqMap.put("WFInstanceID", dockey);
			reqMap.put("ReturnKey", returnkey);
					
			int insResultCnt = gqmsWfService.updGqmsWf(reqMap);	
		} else { // 상태변경
			if(result.equals("P")) { // 결재중
				Status = "1";
			} else if(result.equals("S")) { // 결재완료
				Status = "2";
			} else if(result.equals("R")) { // 반려
				Status = "3";
			} else if(result.equals("D")) { // 삭제 
				Status = "4";
			}
			
			reqMap.put("WFInstanceID", dockey);
			reqMap.put("Status", Status);
			reqMap.put("LastSginer", empid);
			reqMap.put("AppDate", appdate);
			
			int insResultCnt = gqmsWfService.updGqmsWf(reqMap);	
		}
		System.out.println(" GQMS update 완료 ");
		
		return result;
		 
	}
	
	*/
}



