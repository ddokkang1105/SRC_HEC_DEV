package xbolt.custom.lf.web;

import java.net.Inet4Address;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
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
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.lf.val.LfGlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.lf.sap.SapRfcConn;
import xbolt.custom.lf.sap.WpFunction;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * @Class Name : LfController.java
 * @Description : LfController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2015. 12. 17. smartfactory		최초생성
 *
 * @since 2015. 12. 17.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class LfActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "commonOraService")
	private CommonService commonOraService;
	
	@RequestMapping(value="/lf/loginlfForm.do")
	public String loginlfForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setLoginScrnInfo(model,cmmMap);
	  return nextUrl(GlobalVal.HTML_LOGIN_PAGE);
	}

	@RequestMapping(value="/lf/loginlf.do")
	public String loginlf(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
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
			String ref = request.getHeader("referer");
			String protocol = request.isSecure() ? "https://" : "http://";
			
			String isCheck = GlobalVal.PWD_CHECK;
			String url_CHECK = StringUtil.chkURL(ref, protocol);

			if("".equals(isCheck))
				isCheck = "Y";
			
			
			if("".equals(url_CHECK)) {
				if(screenType.equals("link")){ resultMap.put(AJAX_SCRIPT, "fnReload('N')"); 
				}else{ resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')"); }
				//resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
				// LF 요청으로  MSG 제거(Your ID does not exist in our system or password is wrong.\\nPlease contact the system administrator.)
			}
			else {
				String loginActive = "";
				
				if("login".equals(url_CHECK)){
					loginActive = commonService.selectString("login_SQL.login_active_select", cmmMap);
					if(loginActive == "N") loginActive = "";
					cmmMap.put("IS_CHECK", "Y");
				}else{
					Map temp = commonService.select("login_SQL.login_id_selectFromEmpNo", cmmMap);
					loginActive = StringUtil.checkNull(temp.get("LoginId"));
					cmmMap.put("LOGIN_ID", loginActive);
					cmmMap.put("IS_CHECK", "N");
				}
				
				if(loginActive == "") {
					if(screenType.equals("link")){ resultMap.put(AJAX_SCRIPT, "fnReload('N')"); 
					}else{ resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')"); }
					
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
				}else {
					cmmMap.put("active","1");					
					cmmMap.put("LOGIN_ID", loginActive);
					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if(loginInfo == null || loginInfo.size() == 0) {
						if(screenType.equals("link")){ resultMap.put(AJAX_SCRIPT, "fnReload('N')"); 
						}else{ resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')"); }
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));					
					} else {
						// [Authority] < 4 인 경우, 수정가능하게 변경
						if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
						else	loginInfo.put("loginType", "viewer");	
						if(screenType.equals("link")){ resultMap.put(AJAX_SCRIPT, "fnReload('Y')"); 
						}else{ resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')"); }		
						session.setAttribute("loginInfo", loginInfo);
						if(isCheck.equals("N")){
							// Login success이면 LF OTP 무효화 처리 Update
							updateSsoLogStatUpdate(cmmMap);
						}
					}
				}
			}
			model.addAttribute(AJAX_RESULTMAP,resultMap);
			
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	private ModelMap setLoginScrnInfo(ModelMap model,HashMap cmmMap) throws Exception {
		  
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
	  model.put("p1", cmmMap.get("p1"));
	  model.put("p2", cmmMap.get("p2"));
	  model.put("p3", cmmMap.get("p3"));
	  model.put("p4", cmmMap.get("p4"));
	  model.put("p5", cmmMap.get("p5"));
	  return model;
 	}
	
	private void updateSsoLogStatUpdate(HashMap cmmMap) throws Exception {        
		try {
			URL url = new URL("https://ei-gateway-uat.lfcorp.com/services/sso-v3/sso");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("PUT");
			conn.setRequestProperty("Accept", "application/json");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			
			String jsonInputString = "{\"_put_sso\":{\"P1\":\""+cmmMap.get("p1")+"\",\"P2\":\""+cmmMap.get("p2")+"\",\"P3\":\""+cmmMap.get("p3")+"\",\"P4\":\""+cmmMap.get("p4")+"\",\"P5\":\""+cmmMap.get("p5")+"\"}}";
			System.out.println("jsonInputString == "+jsonInputString);
			
			try(OutputStream os = conn.getOutputStream()){
				byte[] input = jsonInputString.getBytes("utf-8");
		    	os.write(input, 0, input.length);
		    	os.flush();
		    	os.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
			
			// 응답 코드 받기.
			int responseCode = conn.getResponseCode();
			System.out.println("updateSsoLogStatUpdate == "+responseCode);
			
			 if (responseCode == 400) {
		            System.out.println("400:: 해당 명령을 실행할 수 없음 ");
		        } else if (responseCode == 401) {
		            System.out.println("401:: X-Auth-Token Header가 잘못됨");
		        } else if (responseCode == 500) {
		            System.out.println("500:: 서버 에러, 문의 필요");
		        } else if (responseCode == conn.HTTP_OK){ // 성공(200)
		            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
		            StringBuilder sb = new StringBuilder();
		            String line = "";
		            while ((line = br.readLine()) != null) {
		                sb.append(line);
		            }
		        }
			
		} catch(IOException e) {
			System.out.println("IOExceptin "+e.getCause());
			e.printStackTrace();
		} catch(Exception e) {
			System.out.println("Exception "+e.getCause());
			e.printStackTrace();
		} 
	}
	
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	// OLM에서 외부 시스템 SAP 호울
	private com.sap.mw.jco.JCO.Client mConnection;
	private com.sap.mw.jco.JCO.Function mFunction;

	@RequestMapping(value="/runLFSAPTransaction.do")
	public String runLFSAPTransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();
		String empNo = StringUtil.checkNull(cmmMap.get("sessionEmployeeNm"));	//사번
		//System.out.println("runSAPLFtransaction()::empNo="+empNo);
		String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
		String attrTypeCode = "AT00014";
		String languageID = GlobalVal.DEFAULT_LANGUAGE;
		
		setMap.put("attrTypeCode", attrTypeCode);
		setMap.put("itemID", itemID);
		setMap.put("languageID", languageID);
		String t_code = commonService.selectString("link_SQL.getAttrValue", setMap);

		if( !StringUtil.checkNull(cmmMap.get("sessionSapEUname")).equals("")){model.put("E_UNAME",StringUtil.checkNull(cmmMap.get("sessionSapEUname")));}
		if( !StringUtil.checkNull(cmmMap.get("sessionSapEPwd")).equals("")){model.put("E_PWD",StringUtil.checkNull(cmmMap.get("sessionSapEPwd")));}
		String E_RESULT = "S";
	
		//==================================================================================
		//session정보를 읽어서 있으면 다시 connection하지 않기		
		if( StringUtil.checkNull(cmmMap.get("sessionSapEUname")).equals("") || StringUtil.checkNull(cmmMap.get("sessionSapEPwd")).equals("")){
		
			//======================================================
			//SAP connection관련
			String strFName = "YZIDM_GET_EMPNO_SAPID"; 
			//empNo = "9500941";
			// 9500941 2037054 9400523
			String E_UNAME = "";
			String E_PWD = "";
		    try {
				if (mFunction == null) {				
					mConnection = SapRfcConn.getClient();
					mFunction = SapRfcConn.createFunc(strFName, mConnection);
				}
				
				mFunction.getImportParameterList().setValue(empNo, "I_PERNR") ;
				//mFunction.getImportParameterList().setValue(tmpSabun, "I_PERNR") ;
				//mFunction.getImportParameterList().setValue("E", "I_SYSTEM") ;
				
				mConnection.execute(WpFunction.execute(mFunction));			
	
				E_UNAME = mFunction.getExportParameterList().getString("E_UNAME");
				E_PWD = mFunction.getExportParameterList().getString("E_PWD");
				E_RESULT = mFunction.getExportParameterList().getString("E_RESULT"); 
				
				model.put("E_UNAME",      E_UNAME);      //SAP ID                     
				model.put("E_PWD",        E_PWD);        //패스워드                   
				//model.put("E_RESULT",     E_RESULT);     //성공'S', 실패'F', 에러'E'  
				model.put("E_MESSAGE",    mFunction.getExportParameterList().getString("E_MESSAGE"));    //결과메세지                 
				model.put("E_LOGON_DATE", mFunction.getExportParameterList().getString("E_LOGON_DATE")); //로그온일자                 
				model.put("E_LOGON_TIME", mFunction.getExportParameterList().getString("E_LOGON_TIME")); //로그온시간                 
				model.put("E_SERVER",     mFunction.getExportParameterList().getString("E_SERVER"));     //서버                       
				model.put("E_MANDT",      mFunction.getExportParameterList().getString("E_MANDT"));      //클라이언트                 
				model.put("E_TERMID",     mFunction.getExportParameterList().getString("E_TERMID"));     //단말기 ID  
			
				System.out.println("SAP Connection:::: E_RESULT="+E_RESULT+":E_MESSAGE="+model.get("E_MESSAGE")); 
				if(E_RESULT.equals("S")) 
				{     
	            	//LNavigationAlter.setReturnUrlName(req , "success" );
					//Session에 저장
					HttpSession session = request.getSession(true);		
					Map loginInfo = (Map)session.getAttribute("loginInfo");
					loginInfo.put("SAP_E_UNAME", E_UNAME);
					loginInfo.put("SAP_E_PWD", E_PWD);
					session.setAttribute("loginInfo", loginInfo);
				} else if(E_RESULT.equals("F")){ 
	            	//LNavigationAlter.setReturnUrlName(req , "logindup" );
	            	 throw new ExceptionUtil("");
	            } else{
	             	//LNavigationAlter.setReturnUrlName(req , "error" );
	             	throw new ExceptionUtil("");
	            }
			} catch (Exception e) {
				if(_log.isInfoEnabled()){_log.info("OlmLinkActionController::runSAPLFtransaction::Error::"+e);}
				//throw new ExceptionUtil(e.toString());
			} finally {
	            mFunction = null;
	            try{if(mConnection!=null){SapRfcConn.releaseClient(mConnection); }}catch(Exception e){}	
	            //SapRfcConn.releaseClient(mConnection);  
				System.out.println("SAP Connection:::: E_PERNR="+empNo+",E_UNAME="+E_UNAME+",E_PWD="+E_PWD+",T_CODE="+t_code); 
			}	
		}else{
			System.out.println("Session Info :: E_PERNR="+empNo+",E_UNAME="+StringUtil.checkNull(cmmMap.get("sessionSapEUname"))+",E_PWD="+StringUtil.checkNull(cmmMap.get("sessionSapEPwd"))+",T_CODE="+t_code); 
		}
		//======================================================
		//===============================================================================================
		model.put("E_PERNR",      empNo);
		model.put("E_RESULT",     E_RESULT);     //성공'S', 실패'F', 에러'E'  
		
		model.put("SAP_CLIENT_NO", LfGlobalVal.SAP_CLIENT_NO);
		model.put("SAP_R3_NAME", LfGlobalVal.SAP_R3_NAME);
		model.put("T_CODE", t_code);		
		
		return nextUrl("/custom/lf/olmLinkSapPopup");
	}
	
	@RequestMapping(value="/closeSAPLFtransaction.do")
	public String closeSAPLFtransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map resultMap = new HashMap<String, String>();
		try{
			
			String strFName = "YZIDM_USER_TERMINATE"; 

		    try {
				if (mFunction == null) {				
					mConnection = SapRfcConn.getClient();
					mFunction = SapRfcConn.createFunc(strFName, mConnection);
				}
			
				mFunction.getImportParameterList().setValue(StringUtil.checkNull(cmmMap.get("i_server")), "I_SERVER") ;
				mFunction.getImportParameterList().setValue(StringUtil.checkNull(cmmMap.get("i_mandt")), "I_MANDT") ;
				mFunction.getImportParameterList().setValue(StringUtil.checkNull(cmmMap.get("i_termid")), "I_TERMID") ;
				mFunction.getImportParameterList().setValue(StringUtil.checkNull(cmmMap.get("i_uname")), "I_UNAME") ;
				mFunction.getImportParameterList().setValue(StringUtil.checkNull(cmmMap.get("i_date")), "I_DATE") ;
				mFunction.getImportParameterList().setValue(StringUtil.checkNull(cmmMap.get("i_time")), "I_TIME") ;
				
				mConnection.execute(WpFunction.execute(mFunction));			

			    //list.setString("E_RESULT", mFunction.getExportParameterList().getString("E_RESULT"));     //�깃났'S', �ㅽ뙣'F', �먮윭'E'  
			    //list.setString("E_MESSAGE", mFunction.getExportParameterList().getString("E_MESSAGE"));    //寃곌낵硫붿꽭吏�                

			    //LLog.debug.println( "SAP ID Termination Result..." );
			    //LLog.debug.println( list );
				
				resultMap.put(AJAX_ALERT, "E_RESULT='"+mFunction.getExportParameterList().getString("E_RESULT")+"', E_MESSAGE="+mFunction.getExportParameterList().getString("E_MESSAGE"));
				resultMap.put(AJAX_SCRIPT, "parent.closeThis();");
				model.addAttribute(AJAX_RESULTMAP,resultMap);
			    
	    		//return list;
			} catch (Exception e) {
	 	 		//throw new LBizException(Constants.MSG_ERROR_RETRIEVE, e);
				if(_log.isInfoEnabled()){_log.info("OlmLinkActionController::closeSAPLFtransaction::Error::"+e);}
				throw new ExceptionUtil(e.toString());
			} finally {
	            mFunction = null;
	            try{if(mConnection!=null){SapRfcConn.releaseClient(mConnection); }}catch(Exception e){}	
	            //SapRfcConn.releaseClient(mConnection);  
			}			
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("OlmLinkActionController::closeSAPLFtransaction::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(AJAXPAGE);
	}
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	@RequestMapping(value="/runLFWEBTransaction.do")
	public String runLFWEBTransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();	
		String url = "";//"/template/emptyPage";
	    try {
	    		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
	    		String itemID = StringUtil.checkNull(request.getParameter("itemID"));
	    		String menuID = "";
	    		String systemType = "";
	    		String empNo = StringUtil.checkNull(cmmMap.get("sessionEmployeeNm"));
	    		String LF_WEP_URL = "";	  		    		
	    		String frap = "OMS";
	    		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	    		SimpleDateFormat formatter2 = new SimpleDateFormat("HHmmss");
				long date = System.currentTimeMillis();
				String OTP = formatter.format(date);
				String time = formatter2.format(date);
				String clientIp =  StringUtil.checkNull(Inet4Address.getLocalHost().getHostAddress());
				
	    		/**
	    		http://10.49.8.196:9006/mdp/index.jsp?protect=Y&userid=MDPADMIN&p0=101&p7=LM:2013:B&p2=SP&p3=MDP&p4=OTP&p5=165.244.91.202
	    		http://10.49.8.203:8081/enovia/servlet/lfcssologin?p0=253&p7=HZPA7C003&userid=MDPADMIN&p2=SP&p3=MDP&p4=<random val>&p5=165.244.91.202
				**/
				List attrTypeInfoList = new ArrayList();
				Map attrMap = new HashMap();	
				setMap.put("languageID", languageID);
				setMap.put("itemID", itemID);				
				attrTypeInfoList = commonService.selectList("link_SQL.getAttrTypeInfoList_gridList", setMap);
				
				attrMap = (Map)attrTypeInfoList.get(0);
				menuID = StringUtil.checkNull(attrMap.get("TCode"));
				systemType = StringUtil.checkNull(attrMap.get("SystemTypeText"));
	    		// MDP/PLM URL 가져오기 
	    		if(systemType.equals("MDP")){
	    			LF_WEP_URL = LfGlobalVal.WEB_MDP_URL;
	    			url = LF_WEP_URL+"?protect=A&userid="+empNo+"&p0="+menuID+"&p2="+frap+"&p3="+systemType+"&p4="+OTP+"&p5="+clientIp;
	    		}else{ 
	    			LF_WEP_URL = LfGlobalVal.WEB_PLM_URL; 
	    			url = LF_WEP_URL+"?p0="+menuID+"&p1="+empNo+"&p2="+frap+"&p3="+systemType+"&p4="+OTP+"&p5="+clientIp;
	    		}
	    		System.out.println("url :: >"+url );
	    		// DB INSERT
	    		setMap.put("userID", empNo);
	    		setMap.put("p2", frap);
	    		setMap.put("p3", systemType);
	    		setMap.put("p4", OTP);
	    		setMap.put("p5", clientIp);
	    		setMap.put("sso1_time", time);
	    		commonOraService.insert("lf_ORASQL.insertTBSSO1", setMap);
	    		
	    		_log.info("LfActionController::runLFWEBTransaction::url::"+url);
	    		
	    }catch (SQLException se) {
			if(_log.isInfoEnabled()){_log.info("LfActionController::runLFWEBTransaction::Error::"+se);}
			throw new ExceptionUtil(se.toString());
		}	   
		return redirect(url);
	}
	
	@RequestMapping(value="/runLFTransaction.do")
	public String runLFTransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();	
		HashMap target = new HashMap();	
		String url = "";
	    try {
	    		String itemID = StringUtil.checkNull(request.getParameter("itemID"));	   	    		
	    		String attrTypeCode = "AT00037";
	    		String languageID = GlobalVal.DEFAULT_LANGUAGE;
	    		
	    		setMap.put("attrTypeCode", attrTypeCode);
	    		setMap.put("itemID", itemID);
	    		setMap.put("languageID", languageID);
	    		String lovCode = commonService.selectString("link_SQL.getAttrValue", setMap);
	    		System.out.println("lovCode :"+lovCode);
	    		if(lovCode.equals("LV37002") || lovCode.equals("LV37003")){
	    			url = runLFWEBTransaction(cmmMap,model,request);
	    		}else if(lovCode.equals("LV37001")){
	    			url = runLFSAPTransaction(cmmMap,model,request);
	    		}else{ 
	    			System.out.println("No system can be executed!");
	    			target.put(AJAX_ALERT,"No system can be executed!");
	    			model.addAttribute(AJAX_RESULTMAP, target);
	    			url = nextUrl(AJAXPAGE);
	    		}
	    		
	    		_log.info("LfActionController::runLFTransaction::url::"+url);
	    		
	    }catch (Exception se) {
			if(_log.isInfoEnabled()){_log.info("LfActionController::runLFTransaction::Error::"+se);}
			throw new ExceptionUtil(se.toString());
		}	   
		return url; 
	}
	
	@RequestMapping(value = "/zLF_getITSAprvPath.do")
	public String zLF_getITSAprvPath(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();

		try {
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			setMap.put("srID", srID);
			setMap.put("languageID", languageID);

			String RequestUserID = StringUtil.checkNull(commonService.selectString("esm_SQL.getESMSRReqUserID", setMap));
			setMap.put("userID", RequestUserID);
			
			Map managerInfo = commonService.select("user_SQL.getSupeiorManagerInfo", setMap);
			
			String itemID = StringUtil.checkNull(commandMap.get("itemID"));
			String roleType = StringUtil.checkNull(commandMap.get("roleType"));
			String assignmentType = StringUtil.checkNull(commandMap.get("assignmentType"));
			
			if(itemID.equals("")){ itemID = StringUtil.checkNull(commonService.selectString("esm_SQL.getESMSRArea2", setMap)); }
			if(roleType.equals("")){ roleType = "I"; }
			if(assignmentType.equals("")){ assignmentType = "SRROLETP"; }
			
			setMap.put("itemID", itemID);
			setMap.put("roleType", roleType); // "I" 
			setMap.put("assignmentType", assignmentType); // "SRROLETP"
			List myItemMemberList = commonService.selectList("esm_SQL.getWFMemberList", setMap);
			
			String wfStepInfo = "";
			String memberIDs = "";
			String roleTypes = "";
			Map itemMemberInfo = new HashMap();
			// 상신자 
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
			
			// 결재 대무자
			setMap.put("userID",RequestUserID);
			setMap.put("roleCategory","WFROLETP");
    		Map mbrAgent = commonService.select("user_SQL.getMemberStatus", setMap);
			
			// 매니저
			String managerID = "";
			String managerName = "";
			String managerTeamID = "";
			String managerTeamName = "";
			
			// 추가 승인자
			String addApproverID = "";
			String myItmMemID = "";
			
			Map map = new HashMap();
			
			setMap.put("roleType","APRV");
			setMap.put("SRID",srID);
			List addApproverList = commonService.selectList("esm_SQL.getESMSRMember", setMap);
			
			if(addApproverList.size() > 0) {
				for(int i =0; i < addApproverList.size(); i++) {
					Map addApprover = (Map) addApproverList.get(i);
					addApproverID =  StringUtil.checkNull(addApprover.get("MemberID"));
					for(int j =0; j < myItemMemberList.size(); j++) {
						Map myItmMem = (Map) myItemMemberList.get(j);
						myItmMemID =  StringUtil.checkNull(myItmMem.get("MemberID"));
						if(addApproverID.equals(myItmMemID)) {
							 addApproverList.remove(i);
							 continue;
						}
					}
				}
			}
			
    		if(mbrAgent != null && !mbrAgent.isEmpty()){
				setMap.put("memberID",mbrAgent.get("AgentID"));
    			Map agentInfo = commonService.select("user_SQL.getMemberInfo", setMap);
    			
    			// 대무자
    			managerID = StringUtil.checkNull(mbrAgent.get("AgentID"));
				managerName = StringUtil.checkNull(mbrAgent.get("Name"));
				managerTeamName = StringUtil.checkNull(agentInfo.get("TeamName"));
				
				if(addApproverList.size() > 0) {
					for(int i =0; i < addApproverList.size(); i++) {
						Map addApprover = (Map) addApproverList.get(i);
						addApproverID =  StringUtil.checkNull(addApprover.get("MemberID"));
						if(addApproverID.equals(managerID)) {
							 addApproverList.remove(i);
							 continue;
						}
					}
				}
				
				if(addApproverList.size() > 0) {
					memberIDs = userID+",";
					roleTypes = "AREQ,";
					wfStepInfo = userName+"("+userTeamName+") >> ";
					for(int i=0; i < addApproverList.size(); i++) {
						map = (Map) addApproverList.get(i);
						memberIDs += StringUtil.checkNull(map.get("MemberID"))+",";
						roleTypes += "APRV,";
						wfStepInfo += StringUtil.checkNull(map.get("SRRefMember"))+" >> ";
					}
					memberIDs += managerID;
					roleTypes += "APRV";
					wfStepInfo += managerName+"("+managerTeamName+")";
				} else {
					memberIDs = userID+","+managerID;
					roleTypes = "AREQ,APRV";
					wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
				}
			} else {
				if(managerInfo != null && !managerInfo.isEmpty()){
					managerID = StringUtil.checkNull(managerInfo.get("ManagerID"));
					managerName = StringUtil.checkNull(managerInfo.get("ManagerNM"));
					managerTeamID = StringUtil.checkNull(managerInfo.get("ManagerTeamID"));
					managerTeamName = StringUtil.checkNull(managerInfo.get("ManagerTeamNM"));
					
					if(addApproverList.size() > 0) {
						for(int i =0; i < addApproverList.size(); i++) {
							Map addApprover = (Map) addApproverList.get(i);
							addApproverID =  StringUtil.checkNull(addApprover.get("MemberID"));
							if(addApproverID.equals(managerID)) {
								 addApproverList.remove(i);
								 continue;
							}
						}
					}
				}
				
				if(!managerID.equals("")){			
					if(addApproverList.size() > 0) {
						memberIDs = userID+",";
						roleTypes = "AREQ,";		
						wfStepInfo = userName+"("+userTeamName+") >> ";
						for(int i=0; i < addApproverList.size(); i++) {
							map = (Map) addApproverList.get(i);
							memberIDs += StringUtil.checkNull(map.get("MemberID"))+",";
							roleTypes += "APRV,";
							wfStepInfo += StringUtil.checkNull(map.get("SRRefMember"))+" >> ";
						}
						memberIDs += managerID;
						roleTypes += "APRV";
						wfStepInfo += managerName+"("+managerTeamName+")";
					} else {
						memberIDs = userID+","+managerID;
						roleTypes = "AREQ,APRV";
						wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
					}
				}else{// manager info null 이면  제거 
					if(addApproverList.size() > 0) {
						memberIDs = userID;
						roleTypes = "AREQ";
						wfStepInfo = userName+"("+userTeamName+")";
						for(int i=0; i < addApproverList.size(); i++) {
							map = (Map) addApproverList.get(i);
							memberIDs += ","+StringUtil.checkNull(map.get("MemberID"));
							roleTypes += ",APRV";
							wfStepInfo += " >> "+StringUtil.checkNull(map.get("SRRefMember"));
						}
					} else {
						memberIDs = userID;
						roleTypes = "AREQ";
						wfStepInfo = userName+"("+userTeamName+")";
					}
					
				}
			}
			
			for(int i=0; i<myItemMemberList.size(); i++){
				itemMemberInfo = (Map)myItemMemberList.get(i); 	
				if(!managerID.equals( StringUtil.checkNull(itemMemberInfo.get("MemberID")) )){
					wfStepInfo = wfStepInfo + " >> " +StringUtil.checkNull(itemMemberInfo.get("WFStep"));
					memberIDs = memberIDs +","+StringUtil.checkNull(itemMemberInfo.get("MemberID"));
					roleTypes = roleTypes +",APRV";
				}
			}
				
				target.put(AJAX_SCRIPT, "fnSetWFStepInfo('"+wfStepInfo+"','"+memberIDs+"','"+roleTypes+"','','')");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/*@RequestMapping
	public String runLFTransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();	
		String url = "/custom/lf/selectLFWebTransactionPop";
	    try {
	    		String languageID = StringUtil.checkNull(request.getParameter("languageID"));
	    		String itemID = StringUtil.checkNull(request.getParameter("itemID"));
		    	Map attrMap = new HashMap();
				attrMap.put("languageID", languageID);
				attrMap.put("s_itemID", itemID);
				attrMap.put("AttrTypeCode", "AT00037");
				attrMap = commonService.select("attr_SQL.getItemAttr", attrMap);
				
				if(!attrMap.get("LovCode").equals("")){
					model.put("lovCode", attrMap.get("LovCode"));				
				}
				
				model.put("itemID", itemID);
				model.put("menu", getLabel(request, commonService));  Label Setting 
	    }catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LfActionController::runLFtransaction::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping
	public String goLFWebTransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();	
		String url = "";
	    try {
	    		String languageID = StringUtil.checkNull(request.getParameter("languageID"));
	    		String itemID = StringUtil.checkNull(request.getParameter("itemID"));
	    		String menuID = StringUtil.checkNull(request.getParameter("menuID"));
	    		String systemType = StringUtil.checkNull(request.getParameter("systemType"));
	    		String parameter = StringUtil.checkNull(request.getParameter("parameter"));
	    		String empNo = StringUtil.checkNull(cmmMap.get("sessionEmployeeNm"));
	    		String LF_WEP_URL = "";	    		
	    		String ip = "192.168.0.29";
	    		String frap = "OMS";
	    		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
				long date = System.currentTimeMillis();
				String OTP = formatter.format(date);
	    		
	    		// http://10.49.8.196:9006/mdp/index.jsp?protect=Y&userid=MDPADMIN&p0=101&p7=LM:2013:B&p2=SP&p3=MDP&p4=OTP&p5=165.244.91.202
	    		// http://10.49.8.203:8081/enovia/servlet/lfcssologin?p0=253&p7=HZPA7C003&userid=MDPADMIN&p2=SP&p3=MDP&p4=<random val>&p5=165.244.91.202
				
	    		// MDP/PLM URL 가져오기 
	    		if(systemType.equals("MDP")){
	    			LF_WEP_URL = LfGlobalVal.WEB_MDP_URL;
	    			url = LF_WEP_URL+"?protect=Y&userid="+empNo+"&p0="+menuID+"&p7="+parameter+"&p2=SP&p3="+systemType+"&p4="+OTP+"&p5="+ip;
	    		}else{ 
	    			LF_WEP_URL = LfGlobalVal.WEB_PLM_URL; 
	    			url = LF_WEP_URL+"?userid="+empNo+"&p0="+menuID+"&p7="+parameter+"&p2=SP&p3="+systemType+"&p4="+OTP+"&p5="+ip;
	    		}
	    		System.out.println("url :: >"+url );
	    		// DB INSERT
	    		setMap.put("userID", empNo);
	    		setMap.put("p2", frap);
	    		setMap.put("p3", systemType);
	    		setMap.put("p4", OTP);
	    		setMap.put("p5", ip);
	    		commonService.insert("lf_SQL.insertTBSSO1", setMap);
	    		
	    }catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LfActionController::goLFWebTransaction::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}	   
		return redirect(url);
	}
*/
}
