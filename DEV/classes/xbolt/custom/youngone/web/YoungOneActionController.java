package xbolt.custom.youngone.web;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;



import javax.annotation.Resource;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.daelim.val.DaelimGlobalVal;
import xbolt.custom.youngone.val.YoungOneGlobalVal;
import xbolt.wf.web.WfActionController;
import xbolt.api.enumType.ErrorCode;
import xbolt.api.enumType.ResponseCode;
import xbolt.api.response.ApiResponse;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

@Controller
@SuppressWarnings("unchecked")
public class YoungOneActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	// 고객용 메인화면
	@RequestMapping(value = "/zYO_customerMain.do")
	public String customerMain(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/youngone/itsm/customerMain"; 
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/custom/youngone/loginYoungoneForm.do")
	public String loginYoungoneForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		model = setLoginScrnInfo(model, cmmMap);
		model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
		model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
		model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
		model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
		model.put("esType", StringUtil.checkNull(cmmMap.get("esType")));
		model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
		model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal")));
		model.put("status", StringUtil.checkNull(cmmMap.get("status")));
		model.put("companyCode", StringUtil.checkNull(cmmMap.get("companyCode")));
		model.put("teamCode", StringUtil.checkNull(cmmMap.get("teamCode")));
		
		return nextUrl("/custom/youngone/login");
	}

	@RequestMapping(value = "/custom/youngone/loginYoungone.do")
	public String loginYoungone(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
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
						"Your ID does not exist in our system. Please contact system administrator(DL Chemical).");
			} else {

				Map idInfo = new HashMap();

				if ("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
					cmmMap.put("IS_CHECK", "Y");
				} else {
					cmmMap.put("IS_CHECK", "N");
				}
				
				// 로그인 ID 체크 ( 사번으로 로그인 ID 찾기 )
				Map temp = commonService.select("login_SQL.login_id_selectFromEmpNo", cmmMap);
				String loginActive = StringUtil.checkNull(temp.get("LoginId"));
				cmmMap.put("LOGIN_ID", loginActive);
				
				// 겸직 체크
				Map tmpMap = new HashMap();
				String teamCode = StringUtil.checkNull(cmmMap.get("teamCode"));
				tmpMap.put("teamCode", teamCode);
				String teamID = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamIDFromTeamCode", tmpMap));
				if("".equals(teamID)) teamID = "0";
				cmmMap.put("teamID",teamID);
				
				String companyCode = StringUtil.checkNull(cmmMap.get("companyCode"));
				tmpMap.put("refTeamCode", companyCode);
				String companyID = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamIDFromRefTeamCode", tmpMap));
				if("".equals(companyID)) companyID = "0";
				cmmMap.put("companyID",companyID);
				
				idInfo = commonService.select("login_SQL.login_id_select", cmmMap);

				if (idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					// resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
				} else {
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId")); // parameter LOGIN_ID 는 사번이므로 조회한 LOGINID로 put
					cmmMap.put("isActive", "Y"); // And ISNULL(A.Active,'') != '0'  조건 추가 
					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if (loginInfo == null || loginInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						// resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
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

	private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap) throws Exception {
		String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		model.addAttribute("loginid", StringUtil.checkNull(cmmMap.get("loginid"), ""));
		model.addAttribute("pwd", pass);
		model.addAttribute("lng", StringUtil.checkNull(cmmMap.get("lng"), ""));

		if (_log.isInfoEnabled()) {
			_log.info("setLoginScrnInfo : loginid=" + StringUtil.checkNull(cmmMap.get("loginid")) + ",pass"
					+ URLEncoder.encode(pass) + ",lng=" + StringUtil.checkNull(cmmMap.get("lng")));
		}
		List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
		if (langList != null && langList.size() > 0) {
			for (int i = 0; i < langList.size(); i++) {
				Map langInfo = (HashMap) langList.get(i);
				if (langInfo.get("IsDefault").equals("1")) {
					model.put("langType", StringUtil.checkNull(langInfo.get("CODE"), ""));
					model.put("langName", StringUtil.checkNull(langInfo.get("NAME"), ""));
				}
			}
		} else {
			model.put("langType", "");
			model.put("langName", "");
		}
		model.put("langList", langList);
		model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
		return model;
	}

	@RequestMapping(value = "/custom/youngone/index.do")
	public String indexYoungone(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
            
			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");
			
			// 기본변수 끝
			String olmI = StringUtil.checkNull(request.getParameter("olmI"), "");// 사번
			String companyCode = StringUtil.checkNull(request.getParameter("companyCode"), ""); // 
			String teamCode = StringUtil.checkNull(request.getParameter("teamCode"), "");
			String langCode = StringUtil.checkNull(request.getParameter("langCode"), "");
			
			// base64 복호화
			byte[] byteStr1 = Base64.decodeBase64(olmI.getBytes());
	        String decodedOlmI = new String(byteStr1);
	        byte[] byteStr2 = Base64.decodeBase64(companyCode.getBytes());
	        String decodedCompanyCode = new String(byteStr2);
	        byte[] byteStr3 = Base64.decodeBase64(teamCode.getBytes());
	        String decodedTeamCode = new String(byteStr3);
	        
	        String olmLng = "";
	        if("EN".equals(langCode)) olmLng = "1033";
	        
			model.put("olmI", decodedOlmI);
			model.put("companyCode", decodedCompanyCode);
			model.put("teamCode", decodedTeamCode);
			model.put("olmLng", olmLng);
			model.put("srID", StringUtil.checkNull(request.getParameter("srID"), ""));
			model.put("srType", StringUtil.checkNull(request.getParameter("srType"), ""));
			model.put("esType", StringUtil.checkNull(request.getParameter("esType"), ""));
			

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("YoungoneActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/indexYoungone");
	}
	
	
	/*
	 * 2025-06-05
	 * 
	 * IM_SYNC_ORG/EMP/EMP_DEPT
	 * 1. TRUNCATE TABLE
	 * 2. JSON ARRAY INSERT TABLE
	 * 
	 * 작성자 : KDY
	 */
	@RequestMapping(value = "/olmapi/imSyncTest.do")
	 public String imSyncTestPage(ModelMap model, HttpServletRequest request) throws Exception {
		  return nextUrl("imSyncTest");
	}
	
	@RequestMapping(value = "/olmapi/imSyncMGT.do", method=RequestMethod.POST, consumes = "application/json; charset=utf-8", produces = "application/json; charset=utf-8")
	public void imSyncMGT(@RequestBody String requestJsonArray, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ApiResponse<?> apiResponse = null;
		ObjectMapper objectMapper = new ObjectMapper();
		
		Map setMap = new HashMap();
		String type = StringUtil.checkNull(request.getHeader("type"), "");
		
		LocalDateTime now = LocalDateTime.now();
		System.out.println("imSyncMGT Start :: " + now);
		
		if (!type.equals("") && (type.equals("ORG") || type.equals("EMP") || type.equals("EMP_DEPT"))) {
			try {
				
				if (type.equals("ORG")) {
					commonService.delete("custom_SQL.zDLMC_deleteImSyncOrg", setMap);
					imSyncApiOrg(requestJsonArray, request, response);
				} else if (type.equals("EMP")) {
					commonService.delete("custom_SQL.zDLMC_deleteImSyncEmp", setMap);
					imSyncApiEmp(requestJsonArray, request, response);
				} else if (type.equals("EMP_DEPT")) {
					commonService.delete("custom_SQL.zDLMC_deleteImSyncEmpDept", setMap);
					imSyncApiEmpDept(requestJsonArray, request, response);
				}
				
				LocalDateTime now2 = LocalDateTime.now();
				System.out.println("imSyncMGT end / success :: " + now2);
				
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
		} else {
			apiResponse = ApiResponse.fail(ErrorCode.BAD_REQUEST, null);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(objectMapper.writeValueAsString(apiResponse));
			
			System.out.println("imSyncMGT end / fail :: " + now);
		}
		
	}
	
	
	@RequestMapping(value = "/olmapi/imSyncApiOrg.do", method=RequestMethod.POST, consumes = "application/json; charset=utf-8", produces = "application/json; charset=utf-8")
	 public void imSyncApiOrg(@RequestBody String requestJsonArray, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ApiResponse<?> apiResponse = null;
	    ObjectMapper objectMapper = new ObjectMapper();
		
		try {
			
			
	        // JSON 배열을 List<Map<String, Object>>로 변환
	        List<Map<String, Object>> dataList = objectMapper.readValue(requestJsonArray, new TypeReference<List<Map<String, Object>>>() {});

	        for (Map<String, Object> getMap : dataList) {
	            commonService.insert("custom_SQL.zDLMC_insertImSyncOrg", getMap);
	        }
		
			apiResponse = ApiResponse.success(ResponseCode.SELECT_SUCCESS.getHttpStatusCode(), null, null);

		}catch(Exception e){
			e.printStackTrace();
		}
		

	    response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().print(objectMapper.writeValueAsString(apiResponse));
	    
	}
	
	@RequestMapping(value = "/olmapi/imSyncApiEmp.do", method=RequestMethod.POST, consumes = "application/json; charset=utf-8", produces = "application/json; charset=utf-8")
	public void imSyncApiEmp(@RequestBody String requestJsonArray, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ApiResponse<?> apiResponse = null;
		ObjectMapper objectMapper = new ObjectMapper();
		
		try {
			// JSON 배열을 List<Map<String, Object>>로 변환
			List<Map<String, Object>> dataList = objectMapper.readValue(requestJsonArray, new TypeReference<List<Map<String, Object>>>() {});
			
			for (Map<String, Object> getMap : dataList) {
				commonService.insert("custom_SQL.zDLMC_insertImSyncEmp", getMap);
			}
			
			apiResponse = ApiResponse.success(ResponseCode.SELECT_SUCCESS.getHttpStatusCode(), null, null);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(objectMapper.writeValueAsString(apiResponse));
		
	}
	
	@RequestMapping(value = "/olmapi/imSyncApiEmpDept.do", method=RequestMethod.POST, consumes = "application/json; charset=utf-8", produces = "application/json; charset=utf-8")
	public void imSyncApiEmpDept(@RequestBody String requestJsonArray, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ApiResponse<?> apiResponse = null;
		ObjectMapper objectMapper = new ObjectMapper();
		
		try {
			// JSON 배열을 List<Map<String, Object>>로 변환
			List<Map<String, Object>> dataList = objectMapper.readValue(requestJsonArray, new TypeReference<List<Map<String, Object>>>() {});
			
			for (Map<String, Object> getMap : dataList) {
				commonService.insert("custom_SQL.zDLMC_insertImSyncEmpDept", getMap);
			}
			
			apiResponse = ApiResponse.success(ResponseCode.SELECT_SUCCESS.getHttpStatusCode(), null, null);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(objectMapper.writeValueAsString(apiResponse));
		
	}
	
	@RequestMapping(value = "/zYO_wfDocMgt.do")
	public String zYO_wfDocMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		 Map<String, Object> result = new HashMap<>();
		 Map<String, Object> target = new HashMap<>();
		 String url = "";
		 try {
			Map<String, Object> label = getLabel(request, commonService, "ERRTP");
    		String srCode = StringUtil.checkNull(request.getParameter("srCode"),""); 
    		String activityLogID = StringUtil.checkNull(request.getParameter("activityLogID"),""); 
	    		
    		Map<String, Object> setData = new HashMap<>();
    			
    		// 1. 결재 중복 체크 
			setData.put("documentNo", srCode);
    		setData.put("documentID", activityLogID);
    		setData.put("status", "0");
			// Select WFInstanceID From XBOLTADM.TB_WF_INST Where DocumentID = 2009 And DocumentNo = 'ACM2411133' And Status = 0
    		String wfInstacceID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfInstanceID", setData));
			
			if(!wfInstacceID.equals("")) { // 이미 상신 데이터가 있으면 리턴 //재상신로직도 확인하기 
				System.out.println("이미 결재가 진행중!!");
				target.put(AJAX_ALERT, "이미 결재가 진행중 입니다.");
				model.addAttribute(AJAX_RESULTMAP, target);
    			return nextUrl(AJAXPAGE);
			}

			// 2. Tb_WF_INST DB 저장
    		result = zYO_createWfDoc_SR(request,result, model, cmmMap);  
    		
    		if(StringUtil.checkNull(result.get("error")).equals("Y")) { 
    			model.addAttribute(AJAX_RESULTMAP, target);
    			return nextUrl(AJAXPAGE);
    		}
    		
    		String inhouse = StringUtil.checkNull(request.getParameter("inhouse"));
    		if(inhouse.equals("")) { // olm  로직으로 결재 
    			
    			url = StringUtil.checkNull(request.getParameter("WFDocURL"));
    			model.put("menu", getLabel(request, commonService)); /*Label Setting*/
    			target.put(AJAX_ALERT, "[내부 전자결재 ] 승인 요청이 완료 되었습니다."); 
				target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
				
    		} else {
	    		// 3. 그룹웨어에 전자결재 생성 및 전송
	    		String gwUrl = GlobalVal.GW_LINK_URL + "/approval/legacy/goFormLinkItsm.do"; // "https://gw.youngonedev.com/approval/legacy/goFormLinkItsm.do"; / OPS : https://econ.youngone.com
	    		result.put("languageID", cmmMap.get("sessionCurrLangType"));
	    		System.out.println(" zYO_createWfDoc_SR  결과  result :"+result);
	    		
	    		Map<String, Object> wfData = zYO_setWfData(request, result, cmmMap);
	    		wfData.put("gwUrl",gwUrl);
	    		
	    		Map<String, Object> gwResponse = sendToGroupware(wfData);
	    		
	    		System.out.println("sendResult ===> "+gwResponse.get("sendResult"));
	    		boolean success = Boolean.parseBoolean(StringUtil.checkNull(gwResponse.get("success")));
	    		
	    		if(success) {
	    			target.put(AJAX_ALERT, label.get("ZLN0026")); // "승인 요청이 완료 되었습니다." -> 서비스 요청자의 ECM 임시저장함에서 결재 문서를 상신해 주시기 바랍니다.
					target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
    	        } else {
    	        	
    	        	// roll back : TB_WF_INST, TB_WF_INST_TXT, TB_WF_STEP_INST, update activity WfinstanceID = null 
    	        	 String wfInstanceID = StringUtil.checkNull(wfData.get("wfInstanceID"));
    	        	 rollbackWfInstance(wfInstanceID);
    	        	
    	            target.put(AJAX_ALERT, label.get("ZLN0027"));  // "전자결재 생성 요청중 오류가 발생하였습니다."
					target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
    	       }
    		}

	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    }
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private void sendJsonResponse(HttpServletResponse response, Map<String, Object> result) throws IOException {
		response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("application/json; charset=UTF-8");
	    ObjectMapper objectMapper = new ObjectMapper();
	    response.getWriter().write(objectMapper.writeValueAsString(result));
	}
	
	// TB_WF_INSTANCE 생성 
	public Map<String, Object> zYO_createWfDoc_SR(HttpServletRequest request, Map<String, Object> result, ModelMap model, HashMap cmmMap) throws Exception {	
	    HashMap setData = new HashMap();
		HashMap insertWFInstData = new HashMap();
		HashMap inserWFInstTxtData = new HashMap();
		HashMap insertWFStepData = new HashMap();
		
		String docSubClass = StringUtil.checkNull(request.getParameter("docSubClass"));
		String docCategory = StringUtil.checkNull(request.getParameter("docCategory"));
		String wfID = StringUtil.checkNull(request.getParameter("defWFID"),""); if(wfID.equals("")) wfID="WF004";
		String srCode = StringUtil.checkNull(request.getParameter("srCode"));
		String srID = StringUtil.checkNull(request.getParameter("srID"));
		// String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"));
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		
		System.out.println("docSubClass :"+docSubClass+",docCategory :"+docCategory+",wfID :"+wfID+", srID:"+srID);
		try {
			setData.put("wfID", wfID);			
			String reqReApprovalYN =  StringUtil.checkNull(request.getParameter("reqReApproval"));
			
			
			// SR MST
			setData.put("srID", srID);
			setData.put("languageID", languageID);
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);	
			
			// Activity Log Info 
			setData.put("activityLogID", StringUtil.checkNull(request.getParameter("activityLogID")));
			Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setData);
			
			
			//////////approverID , approverTeamID 취득 START  //////////////////////////////////////////
		    String srRequestUserID = StringUtil.checkNull(srInfo.get("RequestUserID"));
		    String srRequestTeamID = StringUtil.checkNull(srInfo.get("RequestTeamID"));
		    
		    String procPathID = StringUtil.checkNull(srInfo.get("ProcPathID"));
		    
		    String approverID = srRequestUserID;
		    String approverTeamID = srRequestTeamID;		    
		    
		    // 1. 어플리케이션 변경 [배포-적용] category   ADD120102 : 통합테스트 단계의 담당자에게 임시저장 모듈 담당자 담당자 에게 (ACMROLE02)
		    // 2. SAP/e-Acct 변경 [배포-적용] category ADD120102 : 통합테스트 단계의 담당자에게 임시저장  본사 GT 모듈 담당자(ACMROLE02)
		    // ACM 일반 500073, ACM GT 500074
		    if(StringUtil.checkNull(srInfo.get("Status")).equals("ACM0011") || StringUtil.checkNull(srInfo.get("Status")).equals("ACM1011")) { // AP변경 배포 일때 (이관검토)
				 String getSpeCode = "";// 통합테스트 단계
				 if(procPathID.equals("500074")) { // GT 모듈
					 getSpeCode = "ACM1008"; // ACM-GT 통합 테스트
				 }else { //일반 
					 getSpeCode = "ACM0008"; // ACM-일반 통합 테스트
				 }		
				 
				// 통합테스트 단계의 담당자 정보 
				result.put("speCode", getSpeCode);
				result.put("maxSeq", "Y");
				result.put("srID", srID);
				result.put("languageID", languageID);
				Map getAtivityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", result); // 통합테스트 단계 
				String getActorID = StringUtil.checkNull(getAtivityLogInfo.get("ActorID"));
				String getActorTeamID = StringUtil.checkNull(getAtivityLogInfo.get("TeamID"));
				
				approverID = getActorID;
				approverTeamID = getActorTeamID;
		    }
		    System.out.println("approverID :"+approverID+",approverTeamID: "+approverTeamID+", sr status : "+StringUtil.checkNull(srInfo.get("Status")));
		    result.put("approverID", approverID);
		    result.put("approverTeamID", approverTeamID);
		    
		    //////////approverID , approverTeamID 취득 END  //////////////////////////////////////////    
			if(reqReApprovalYN.equals("Y")) { // 결재가 삭제 -1 상태여서 재승인요청 일경우
				// 1. wf-inst Status:0, 
				
				String activityWFInstanceID = StringUtil.checkNull(activityLogInfo.get("ActivityWFInstanceID")); // 재상신할 wfinstanceID
				result.put("wfInstanceID", activityWFInstanceID);
				result.put("subject", "[ITSM]" +  StringUtil.checkNull(srInfo.get("Subject")));
				
			} else { // if(!reqReApprovalYN.equals("Y")) { // 재요청이 아닐경우 신규생성
				/*
				//SET NEW WFInstance ID
				String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setData);
				String initLen = "%0" + (13-GlobalVal.OLM_SERVER_NAME.length()) + "d";
				
				int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(GlobalVal.OLM_SERVER_NAME.length()));
				int maxcode = maxWFInstanceID2 + 1;
				String newWFInstanceID = GlobalVal.OLM_SERVER_NAME + String.format(initLen, maxcode);
				 */
				setData.put("wfID",wfID);
				setData.put("wfDocType",docCategory);
				setData.put("docSubClass",docSubClass);
				
				String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAllocID", setData),"69");
				
				//setData.put("newWFInstanceID",newWFInstanceID);
				setData.put("wfAllocID",wfAllocID);
						
				setData.put("wfStepMemberIDs", StringUtil.checkNull(cmmMap.get("sessionUserId"))); 
				setData.put("wfStepRoleTypes", "AREQ");
				setData.put("wfStepInfo", StringUtil.checkNull(cmmMap.get("sessionUserNm")));
			
			
				String subject = StringUtil.checkNull(srInfo.get("Subject")); 
				setData.put("subject", "[ITSM]" + subject);
				
				// 결재 본문 
				setData.put("speCode", StringUtil.checkNull(srInfo.get("Status")));
				setData.put("srType", StringUtil.checkNull(srInfo.get("SRType")));
				
				setData.put("docCategory", "SR");
				setData.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
					
				// SR ATTR		
				List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttrList", setData);
				System.out.println("srAttrList :"+srAttrList);
				srAttrList = ESPUtil.getSRAttrList(commonService, srAttrList, setData, languageID );
				
				String description =  "";
				if(srAttrList.size()>0) {
					for(int i=0; i<srAttrList.size(); i++) {
						Map attrInfo = (Map)srAttrList.get(i);
						if( !StringUtil.checkNull(attrInfo.get("PlainText")).equals("")) {
							description += "&lt;br&gt;"+ StringUtil.checkNull(attrInfo.get("Name")) + " : " +StringUtil.checkNull(attrInfo.get("PlainText"));
						}
					}
					description += "&lt;br&gt;&lt;br&gt;";
				}
				
				setData.put("description", description);
				System.out.println("srAttrdescriptionList :"+srAttrList);
				
				// 결재 정보 생성 
				// String aprvOption = "POST";if(speCode.equals("ACM0010")) {  aprvOption = ""; }  // 배포부서 승인요청이 아니면 aprvOption : POST 로 insert ::: 
				
				String projectID = StringUtil.checkNull(srInfo.get("ProjectID"));
				
				String loginUser = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String creatorTeamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
				
				String getWfStepMemberIDs = StringUtil.checkNull(setData.get("wfStepMemberIDs"));
				String getWfStepRoleTypes = StringUtil.checkNull(setData.get("wfStepRoleTypes"));
				
				String wfStepMemberIDs[] = null;
				String wfStepRoleTypes[] = null;
				String wfStepSeq[] = null;
				
				if(!getWfStepMemberIDs.isEmpty()){ wfStepMemberIDs = getWfStepMemberIDs.split(","); }
				if(!getWfStepRoleTypes.isEmpty()){ wfStepRoleTypes = getWfStepRoleTypes.split(","); wfStepSeq = getWfStepRoleTypes.split(",");}
				
				// SET APRV PATH	
				int idx = 0;
									
				for(int j=0; j< wfStepRoleTypes.length; j++){	
					if(j == 0){						
						wfStepSeq[j] = "0";
						idx++;
					} else {						
						wfStepSeq[j] = StringUtil.checkNull(idx);
						idx++;
					}
				}
	
				int lastSeq = idx-1;		
								
				//Delete WF Instance Text 
				if (!"".equals(StringUtil.checkNull(request.getParameter("wfInstanceID")))) {
					setData.put("wfInstanceID", StringUtil.checkNull(request.getParameter("wfInstanceID")));
					commonService.delete("wf_SQL.deleteWFInstTxt", setData);
				}
				String status = "0";
				
				// 결재 최최 생성 :  wf_inst.status = 0 --> submit 시 결재 진행중 update 1 -----> 최종 결재시 2  or 3 나머지는 path 에 update
				//INSERT NEW WF Instance
				//insertWFInstData.put("WFInstanceID", newWFInstanceID);
				insertWFInstData.put("ProjectID", projectID);
				insertWFInstData.put("DocumentID", StringUtil.checkNull(request.getParameter("activityLogID")));
				insertWFInstData.put("DocumentNo", srCode);
				insertWFInstData.put("DocCategory", docCategory);
				insertWFInstData.put("WFID", wfID);
				insertWFInstData.put("LastUser", loginUser);
				insertWFInstData.put("Status", status); // 상신
				insertWFInstData.put("curSeq", "1");
				insertWFInstData.put("LastSigner", loginUser);
				insertWFInstData.put("lastSeq", lastSeq);
				insertWFInstData.put("creatorTeamID", creatorTeamID);
				insertWFInstData.put("wfAllocID", wfAllocID);
				insertWFInstData.put("Creator", loginUser);
				insertWFInstData.put("prefix", GlobalVal.OLM_SERVER_NAME);
				insertWFInstData.put("padLen", 10);
				
				System.out.println("insert WF : "+insertWFInstData);
				commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);
				String newWFInstanceID = (String) insertWFInstData.get("WFInstanceID");
				
				System.out.println("newWFINstanceID :"+newWFInstanceID);
				
				//INSERT WF STEP INST
				/*
				String maxId = "";
				if(!getWfStepMemberIDs.isEmpty()){
					for(int i=0; i< wfStepMemberIDs.length; i++){	
											
						status = null ;
						
						insertWFStepData.put("Seq", wfStepSeq[i]);
						maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
						
						insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1); 						
						insertWFStepData.put("ProjectID", projectID);
						
						if( i == 0){ status = "1"; }		
						else if( wfStepSeq[i].equals("1") ){ status = "0"; }
						insertWFStepData.put("Status", status);
						insertWFStepData.put("ActorID", wfStepMemberIDs[i]);
						insertWFStepData.put("WFID", wfID);
						insertWFStepData.put("WFStepID", wfStepRoleTypes[i]);
						if(wfInstanceID.isEmpty()){ insertWFStepData.put("WFInstanceID", newWFInstanceID); }
						commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
					}
				}
				*/
				
				//INSERT WF INST TEXT(SUBJECT, DECSRIPTION)
				inserWFInstTxtData.put("WFInstanceID",newWFInstanceID);
				inserWFInstTxtData.put("subject",subject);
				inserWFInstTxtData.put("subjectEN",subject);
				inserWFInstTxtData.put("description",description);
				inserWFInstTxtData.put("descriptionEN",description);
				inserWFInstTxtData.put("comment","");
				inserWFInstTxtData.put("actorID",loginUser);
				commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);	
				
				String inhouse = StringUtil.checkNull(request.getParameter("inhouse"));
				setData.put("PID", srID);
				setData.put("WFInstanceID", newWFInstanceID);
				if(!inhouse.equals("Y")) {		// olm wf 일경우만 		
					setData.put("Blocked", "1");
					setData.put("Status", "02"); //승인중
				}
				commonService.update("esm_SQL.updateActivityLog", setData);
				
				result.put("wfInstanceID", newWFInstanceID);
				result.put("subject", subject);
				
				if(!inhouse.equals("Y")) {// OLM 로직 결재 일때만 해당됨 (GW X)
					model.put("srInfo", srInfo);
					model.put("activityLogInfo", activityLogInfo);
					model.put("srID", srID);
					
					// 프로세스 흐름을 위한 승인자 임의 설정 ::: APRV  결재 선 승인자 insert 
					insertWFStepData.put("Seq", 1);
					String maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
					
					insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1); 				
					insertWFStepData.put("Status", "0");
					insertWFStepData.put("ActorID", srInfo.get("RequestUserID"));
					insertWFStepData.put("WFID", wfID);
					insertWFStepData.put("WFStepID", "APRV");
					insertWFStepData.put("WFInstanceID", newWFInstanceID); 
					commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
					
					String defWFID = StringUtil.checkNull(request.getParameter("defWFID"),"");
					if("".equals(defWFID)) {
						setData.put("wfDocType", docCategory); // docCategory
						setData.put("docSubClass", StringUtil.checkNull(request.getParameter("docSubClass"),"")); 
						defWFID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFIDForTypeCode", setData));
					}
					
					
					// 결재 테이블 바로 상신으로 status = "1", lastSeq = 1
					setData.put("Status", "1"); 
					setData.put("lastSeq", "1");
					setData.put("WFInstanceID", newWFInstanceID); 
					setData.put("LastUser", loginUser); 
					commonService.update("wf_SQL.updateWfInst", setData);
					
					setData.put("WFID",defWFID); 
					model.put("wfID",defWFID);
					String stepName = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFURL", setData)); // zDlm_wfPathITSM
					cmmMap.put("funcType",stepName);
					
					HashMap returnMap = WfActionController.wfPathMgt(model,cmmMap,request);
					String memberIDs = StringUtil.checkNull(returnMap.get("memberIDs"));
					String roleTypes = StringUtil.checkNull(returnMap.get("roleTypes"));		
					String wfStepInfo = StringUtil.checkNull(returnMap.get("wfStepInfo"));
					
					System.out.println("newWFInstanceID :"+newWFInstanceID);
					model.put("wfInstanceID", newWFInstanceID);
					model.put("wfStepMemberIDs", memberIDs);
					model.put("wfStepRoleTypes", roleTypes);
					model.put("wfStepInfo", wfStepInfo);
					
					model.put("description", description);
					model.put("isPop","Y");
					model.put("docSubClass", StringUtil.checkNull(request.getParameter("docSubClass")));
					model.put("docCategory", StringUtil.checkNull(request.getParameter("docCategory")));
				}
			}
		} catch(Exception e) {
			result.put("success", false);
			result.put("error", "Y");
	        //result.put("message", e.getMessage());
			System.out.println("결재 TB_WF_INST 생성중 오류발생 :"+e);
	        result.put("message", "결재 TB_WF_INST 생성중 오류발생");
		}
		
	    return result;
	}
	
	// 전자결재 정보 조회 및 설정
	public Map<String, Object> zYO_setWfData(HttpServletRequest request, Map<String, Object> result,  HashMap cmmMap ) throws Exception {
		/*
			임시 저장함 호출 url : https://gw.youngonedev.com/approval/legacy/goFormLinkItsm.do  
			파라미터 : 사번(oImI), 회사코드(companyCode), 부서코드(teamCode), html(bodyContext)  
		*/
		try {
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			result.put("srID", srID);
			result.put("languageID", "1033");
			Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", result);
			
		    String wfInstanceID = StringUtil.checkNull(result.get("wfInstanceID")); //"2265f503d7df40d7a737b9ed13b2c1cd"
		    String approverID = StringUtil.checkNull(result.get("approverID"));
		    String approverTeamID = StringUtil.checkNull(result.get("approverTeamID"));	    
		   
		    result.put("teamID", approverTeamID); // "userTeamCompanyID"
		    String companyID = commonService.selectString("user_SQL.userTeamCompanyID", result);  	    
		    result.put("teamID", companyID);		      
		    String companyCode = commonService.selectString("organization_SQL.getTeamCode", result);  
		   
		    result.put("teamID", approverTeamID);	   
			String teamCode = commonService.selectString("organization_SQL.getTeamCode", result);  // "H00003_1000";
			
			result.put("userID", approverID); 	  
			String olmI = StringUtil.checkNull(commonService.selectString("user_SQL.getEmployeeNum",result)); //"woonglee@youngone.com";			
			String userName = StringUtil.checkNull(commonService.selectString("user_SQL.userName", result)); // srRequestUserName			
			String teamName = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamName", result)); // srRequestTeamName
			
			String subject = StringUtil.checkNull(srInfoMap.get("Subject"));
			subject = "[ITSM] "+ StringEscapeUtils.escapeHtml4(subject); // 특수문자 오류 예방
			
			// 진행이력 조회 
			result.put("speCode", StringUtil.checkNull(srInfoMap.get("Status")));
			if(StringUtil.checkNull(request.getParameter("reqReApproval")).equals("Y")) { // 재상신일 경우 결재 단계의 진행 이력이 조회 되도록
				result.put("activityLogID", StringUtil.checkNull(request.getParameter("activityLogID")));
				result.remove("speCode");
			} else {
				result.put("maxSeq", "Y");
			}
			Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", result);
			System.out.println("activityLogInfo ===>"+activityLogInfo);
			
			// 담당자 정보 
			String actorName = StringUtil.checkNull(activityLogInfo.get("ActorName"));
			String actorTeamName = StringUtil.checkNull(activityLogInfo.get("TeamName"));
			String actorInfo = actorName + " / " + actorTeamName;
			
			// 진행이력 속성 정보  
			result.put("docCategory", "SR");
			result.put("srType", StringUtil.checkNull(srInfoMap.get("SRType")));
			result.put("speCode", StringUtil.checkNull(srInfoMap.get("Status"))); // ## 서비스 접수 일경우 REQ0009 이지만 배포 일경우 speCode 수정해야함
			if(StringUtil.checkNull(request.getParameter("reqReApproval")).equals("Y")) { // 재상신일 경우 결재 단계의 진행 이력이 조회 되도록
				result.put("speCode", StringUtil.checkNull(activityLogInfo.get("speCode")));
			}
			
			if(StringUtil.checkNull(srInfoMap.get("SRType")).equals("ACM")) { //AP변경일경우 요청부서와 배포부서 모두 ACM0005(변경 계획 수립)의 속성인 변경계획개요(SRAT0016) 조회 되도록 
				result.put("speCode", "ACM0005"); 
			}
			
			List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttr", result); 
			
			/*
			SRAT0110 작업/변경 계획 개요 : 서비스요청 접수 500057
			SRAT0110 작업/변경 계획 개요 : 서비스요청접수 1선  500076
			SRAT0113 작업/변경 계획 개요(2선) :  서비스요청접수 2선  500076
			
			SRAT0016 변경계획개요 : AP 변경 승인요청 500073
			SRAT0054 변경적용 예상결과 : 시스템 작업 승인 500069
			
			-------------------
			SRAT0117 배포시작예정일시~SRAT0118 배포종료예정일시
			
			*/
			
			List<String> validSRAttrTypeCode = Arrays.asList("SRAT0110", "SRAT0113", "SRAT0016", "SRAT0054"); 
			String opinion ="";
				
			for (Object item : srAttrList) {
			    if (item instanceof Map) {
			        Map attr = (Map) item;
			        String typeCode = StringUtil.checkNull(attr.get("AttrTypeCode"));
			        
			        if (validSRAttrTypeCode.contains(typeCode)) {			        	
			        	opinion = StringUtil.checkNull(attr.get("PlainText"));
			        	opinion = opinion.replaceAll("(\r\n|\n)", "<br>");
			        }
			        
			        if (StringUtils.isNotBlank(opinion)) {
			            break;
			        }
			    }
			}
			
			String SRAT0117 ="";String SRAT0118 ="";
			String SRAT0121 = ""; // SRAT0121비고 (배포 전달사항)
			String SRAT0116 = ""; // CTS번호 (배포-GT)
			
			String wfFormID = "680"; //"WF_FORM_ITSM_01";
			if(StringUtil.checkNull(srInfoMap.get("Status")).equals("ACM0011") || StringUtil.checkNull(srInfoMap.get("Status")).equals("ACM1011")) { //AP변경 배포 일경우만 조회되도록
				wfFormID = "681"; //"WF_FORM_ITSM_02";
				// SR ATTR
				Map setData = new HashMap();
				result.put("speCode", StringUtil.checkNull(srInfoMap.get("Status"))); 
				setData.put("speCode", StringUtil.checkNull(srInfoMap.get("Status"))); 
				setData.put("srType", StringUtil.checkNull(srInfoMap.get("SRType")));
				setData.put("srID", StringUtil.checkNull(srInfoMap.get("SRID"))); 
				setData.put("docCategory", "SR");
				setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
				
				List srAttrListAcm = (List)commonService.selectList("esm_SQL.getSRAttr", setData); // 배포 
				for (Object item2 : srAttrListAcm) {
				    if (item2 instanceof Map) {
				        Map attrAcm = (Map) item2;
				        String attrTypeCode = StringUtil.checkNull(attrAcm.get("AttrTypeCode"));
				        
				        if(attrTypeCode.equals("SRAT0117")) {
				        	SRAT0117 = StringUtil.checkNull(attrAcm.get("PlainText"));  
				        }
				        
				        if(attrTypeCode.equals("SRAT0118")) {
				        	SRAT0118 = StringUtil.checkNull(attrAcm.get("PlainText"));  
				        }
				        
				        if(attrTypeCode.equals("SRAT0121")) {
				        	SRAT0121 = StringUtil.checkNull(attrAcm.get("PlainText"));  
				        	SRAT0121 = SRAT0121.replaceAll("(\r\n|\n)", "<br>");
				        }
				        
				        if(attrTypeCode.equals("SRAT0116")) {
				        	SRAT0116 = StringUtil.checkNull(attrAcm.get("PlainText"));  
				        }
				    }
				}
			}
						
	        LocalDateTime now = LocalDateTime.now();// 현재 날짜와 시간        
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"); // 원하는 포맷 정의       
	        String currTime = now.format(formatter); // 포맷 적용
	        
	        Map setData = new HashMap();
	        setData.put("srID", srID);
	        setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			List activityFileList = commonService.selectList("esm_SQL.espFile_gridList", setData);
			String OLM_SERVER_URL =  StringUtil.checkNull(GlobalVal.OLM_SERVER_URL);
			
			String description = StringUtil.checkNull(srInfoMap.get("Description"));
			description = normalizeLineHeight(description); // line-height가 100% 이하인 경우 → "line-height: 1.4;"로 바꿔서 출력  
			description = description.replaceAll("(\r\n|\n)", "<br>");
			
			Map<String, Object> label = getLabel(request, commonService, "LN", "1033");
	        
	        // 작성자: SR요청자, 접수자: activity 담당자 
			StringBuilder bodyContext = new StringBuilder();

			bodyContext.append("<style>")
			    .append(".styled-table { width: 100%; border-collapse: collapse; font-family: '맑은 고딕', sans-serif; font-size: 13px; word-break: break-all; word-wrap: break-word; margin-top: 30px; }")
			    .append(".styled-table th, .styled-table td { border: 1px solid #ccc; padding: 8px 10px; text-align: left; }")
			    .append(".styled-table th { background-color: #f1f6f9; font-weight: bold; }")
			    
			    .append(".td-content {max-width: 560px; overflow-x: auto; overflow-y: visible;}")  /* td 안의 콘텐츠는 max-width 제한 + 가로 스크롤 */
			    .append(".td-content table {width: 100%;max-width: 100%;border-collapse: collapse;table-layout: auto;}") /* 내부 표는 무조건 부모 div에 따라 감싸짐 */
			    .append(".styled-table .section-header { background-color: #f1f6f9; text-align: center; font-size: 14px; font-weight: bold; }")
			    .append(".styled-table .group-header th { background-color: #f1f6f9; text-align: center; }")
			    .append("</style>");

			bodyContext.append("<table class=\"styled-table\"><colgroup><col style=\"width: 20%;\"><col style=\"width: 80%;\"></colgroup><tbody>")
			    .append("<tr><th class=\"section-header\" colspan=\"2\">Request Info</th></tr>") // 요청정보
			    .append("<tr><th>Ticket ID</th><td>").append(StringUtil.checkNull(srInfoMap.get("SRCode"))).append("</td></tr>") //TicketID
			    .append("<tr><th>"+label.get("LN00025")+"</th><td>").append(userName).append("</td></tr>") // 요청자
			    .append("<tr><th>"+label.get("LN00026")+"</th><td>").append(teamName).append("</td></tr>") // 요청 조직 (요청 부서:영원양식)
			    .append("<tr><th>"+label.get("ZLN0024")+"</th><td>") // 서비스/파트 (서비스대상 : 영원양식) 
			    .append(StringUtil.checkNull(srInfoMap.get("SRArea1Name"))).append(" / ")
			    .append(StringUtil.checkNull(srInfoMap.get("SRArea2Name"))).append("</td></tr>")
			    .append("<tr><th>"+label.get("LN00217")+"</th><td>") // 서비스유형 ( 유형뷴류 :영원양식명)
			    .append(StringUtil.checkNull(srInfoMap.get("CategoryName"))).append(" / ")
			    .append(StringUtil.checkNull(srInfoMap.get("SubCategoryName"))).append("</td></tr>")
			    .append("<tr><th>"+label.get("LN00222")+"</th><td>") //완료 희망 일시
			    .append(StringUtil.checkNull(srInfoMap.get("ReqDueDate")).substring(0, 10)).append("</td></tr>")
			    .append("<tr><th>"+label.get("LN00003")+"</th><td><div class=\"td-content\">") // 요청한 업무(요청 내용:영원양식)
			    .append(description).append("</div></td></tr>")
			    .append("<tr><th class=\"section-header\" colspan=\"2\">Request Analysis Info</th></tr>") // 접수 정보 
			    .append("<tr><th>"+label.get("ZLN0087")+"</th><td>").append(actorInfo).append("</td></tr>") // 담당자 
			    .append("<tr><th>"+label.get("LN00284")+"</th><td>").append(opinion).append("</td></tr>") // 의견
			    .append("</tbody></table>");

			
			// 배포 계획 정보  일반 ACM0011 이관검토, GT ACM1011 이관검토
			if(StringUtil.checkNull(srInfoMap.get("Status")).equals("ACM0011") || StringUtil.checkNull(srInfoMap.get("Status")).equals("ACM1011")) {
				bodyContext.append("<table class=\"styled-table\"><colgroup><col style=\"width: 20%;\"><col style=\"width: 80%;\"></colgroup><tbody>")		  
			    .append("<tr><th class=\"section-header\" colspan=\"2\">Deployment Review Info</th></tr>") // 배포 계획 정보
			    .append("<tr><th>"+label.get("ZLN0087")+"</th><td>").append(actorInfo).append("</td></tr>") //담당자
			    .append("<tr><th>"+label.get("ZLN0064")+"</th><td>").append( SRAT0117 +"~"+SRAT0118 ).append("</td></tr>"); // 배포 희망 일시 (SRAT0117 배포시작예정일시~SRAT0118 배포종료예정일시)
			    
			    if(StringUtil.checkNull(srInfoMap.get("Category")).equals("ADD130")) { // SAP 
			    	bodyContext.append("<tr><th>"+label.get("ZLN0195")+"</th><td>").append(SRAT0116).append("</td></tr>"); // 배포 번호
			    }else {// IT
			    	bodyContext.append("<tr><th>"+label.get("ZLN0196")+"</th><td>").append(SRAT0121).append("</td></tr>"); // 비고(배포 전달사항)
			    }
			    bodyContext.append("</tbody></table>");
			}
			
			// 첨부문서 
			bodyContext.append("<table class=\"styled-table\">")
			    .append("<colgroup><col style=\"width: 80%;\"><col style=\"width: 20%;\"></colgroup><tbody>")
			    .append("<tr><th class=\"section-header\" colspan=\"2\">Attached Files</th></tr>") // 첨부파일
			   // .append("<tr><th class=\"section-header\"><input type=\"checkbox\" name=\"relatedDocChk\" value=\"YOH.H00008-25-0312\" /></th>")
			    .append("<tr><th class=\"section-header\">File Name</th><th class=\"section-header\">Size (KB)</th></tr>"); // 파일명

		   System.out.println("activityFileList:"+activityFileList);
		   if (activityFileList != null && !activityFileList.isEmpty()) {
			    for (int i = 0; i < activityFileList.size(); i++) {
			        Map fileInfo = (Map) activityFileList.get(i);
			        String seq = StringUtil.checkNull(fileInfo.get("Seq"));
			        String fileName = StringUtil.checkNull(fileInfo.get("FileRealName"));
			        String fileSize = StringUtil.checkNull(fileInfo.get("FileSize"));

			        String formattedSize = fileSize; // 기본값 (null 대비)
			        if (!fileSize.isEmpty()) {
			            try {			                
			            	// Byte → KB 변환 & 반올림
			                long size = Long.parseLong(fileSize);
				            // KB 변환 + 반올림
				            long sizeKB = Math.round(size / 1024.0);	
				             // 천단위 포맷
				             DecimalFormat df = new DecimalFormat("#,###");
				             formattedSize = df.format(sizeKB) + " KB";
				             
			            } catch (NumberFormatException e) {
			                // 숫자가 아니면 그냥 원래 값 그대로 사용
			                formattedSize = fileSize;
			            }
			        }
			        bodyContext.append("<tr>")
			           // .append("<td style=\"text-align: center;\"><input type=\"checkbox\" name=\"relatedDocChk\" value=\"YOH.H00008-25-0312\" /></td>")
			            .append("<td><a href=\"").append(OLM_SERVER_URL).append("custom/zDlm_InboundLink.do?linkID=")
			            .append(seq).append("\" target=\"_blank\">").append(fileName).append("</a></td>")
			            .append("<td style=\"text-align: right;\" >").append(formattedSize).append("</td>")
			            .append("</tr>");
			    }
			}
			bodyContext.append("</tbody></table>");
			 
			result.put("wfInstanceID", wfInstanceID);
			result.put("success", true);
			result.put("subject", subject);
			
			result.put("olmI", olmI); // 사번
			result.put("companyCode", companyCode); // 회사코드
			result.put("teamCode", teamCode); // 부서코드
			
			String encodedBodyContext = new String(Base64.encodeBase64(bodyContext.toString().getBytes(StandardCharsets.UTF_8)),StandardCharsets.UTF_8);
			result.put("bodyContext", encodedBodyContext); // 본문 데이터, 본문 HTML	
			result.put("wfFormID", wfFormID); // IT서비스요청서:WF_FORM_ITSM_01/ 시스템변경 요청서: WF_FORM_ITSM_02
			
			//################### Email전송  ###################
			
			/*
			
			Map setMailData = new HashMap();
			//send Email
			String emailCode = "ESPMAIL006"; // 결재 승인요청  메일 코드 
			setMailData.put("EMAILCODE", emailCode);
			setMailData.put("subject", StringUtil.checkNull(srInfoMap.get("Subject")));
		
			// [00]  이메일 수신자 조회 
			Map setEmailReceiverParam = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			// [03] 메일 수신자 정보
			setEmailReceiverParam.put("srID",srID);
			setEmailReceiverParam.put("type","EMAIL");
			setEmailReceiverParam.put("languageID", languageID);
			setEmailReceiverParam.put("emailCode",emailCode);
			List receiverList = commonService.selectList("esm_SQL.getSREmailReceiverList", setEmailReceiverParam);
			System.out.println("결재 email receiverList :"+receiverList);
			setMailData.put("receiverList", receiverList);
			
			Map setMap = new HashMap();
			setMap.put("wfInstanceID",wfInstanceID);
			setMap.put("LanguageID",cmmMap.get("sessionCurrLangType"));
			Map wfInstInfo = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
			
			Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, emailCode);
			System.out.println("setMailMapRst( [Youngone 결재 승인요청 ] ) :  "+setMailMapRst );
			
			setMap.put("emailCode", emailCode);// ESPMAIL006
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
			System.out.println("emailHTMLForm :"+emailHTMLForm);
	        
			HashMap setMailMap = new HashMap();
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				setMailMap.put("srID", srID);
				setMailMap.put("srType", StringUtil.checkNull(srInfoMap.get("SRType")));
				setMailMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				HashMap cntsMap = new HashMap();
				cntsMap.put("getSRInfoMap", srInfoMap);
				cntsMap.put("wfInstInfo", wfInstInfo);
				cntsMap.put("emailHTMLForm", emailHTMLForm);
				
				cntsMap.put("srID", srID);	
				cntsMap.put("teamID", StringUtil.checkNull(srInfoMap.get("RequestTeamID")));					
				cntsMap.put("userID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
				cntsMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
				cntsMap.put("loginID", requestLoginID);
				System.out.println("youngoneController   cntsMap:"+cntsMap);
				
				cntsMap.put("SRCode", StringUtil.checkNull(srInfoMap.get("SRCode")));
				cntsMap.put("Subject", StringUtil.checkNull(srInfoMap.get("Subject")));
				cntsMap.put("ReqUserNM", StringUtil.checkNull(srInfoMap.get("ReqUserNM")));
				cntsMap.put("ReqTeamNM", StringUtil.checkNull(srInfoMap.get("ReqTeamNM")));
				cntsMap.put("SRArea1Name", StringUtil.checkNull(srInfoMap.get("SRArea1Name")));
				cntsMap.put("SRArea2Name", StringUtil.checkNull(srInfoMap.get("SRArea2Name")));
				cntsMap.put("ReqTeamNM", StringUtil.checkNull(srInfoMap.get("ReqTeamNM")));
				cntsMap.put("CategoryName", StringUtil.checkNull(srInfoMap.get("CategoryName")));
				cntsMap.put("ReceiptName", StringUtil.checkNull(srInfoMap.get("ReceiptName")));
				
				// 요청자 parentOrgPath
				Map tempMap = new HashMap();
				String RequestTeamID = StringUtil.checkNull(srInfoMap.get("RequestTeamID"));
				if(!"".equals(RequestTeamID)){
					tempMap.put("s_itemID", RequestTeamID);
					tempMap.put("languageID", "1033");
					Map reqUserMap = commonService.select("organization_SQL.getOrganizationInfo", tempMap);
					String ParentOrgPath = StringUtil.checkNull(reqUserMap.get("ParentOrgPath"));
					cntsMap.put("ParentOrgPath", ParentOrgPath);
				}
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			*/
			//###############################################################
		
			// Activity Update
			//ESPUtil.srAprvProcessingMaster(request,commonService,cmmMap);
			
	} catch(Exception e) {
		result.put("success", false);
		result.put("error", "Y");
        //result.put("message", e.getMessage());
		System.out.println("오류 남 msg :"+e);
        result.put("message", "결재 생성하다 난 오류입니다.");
	}

	    return result;
	}
		
	
	private static String normalizeLineHeight(String html) {
		if (html == null || html.isEmpty()) return html;

        String processed = html;

        // 1. line-height: XX% → 1.4 if XX <= 100
        Pattern lhPattern = Pattern.compile("line-height:\\s*(\\d+)%");
        Matcher lhMatcher = lhPattern.matcher(processed);
        StringBuffer lhBuffer = new StringBuffer();
        while (lhMatcher.find()) {
            int percent = Integer.parseInt(lhMatcher.group(1));
            if (percent <= 100) {
                lhMatcher.appendReplacement(lhBuffer, "line-height: 1.4;");
            } else {
                lhMatcher.appendReplacement(lhBuffer, lhMatcher.group(0)); // 그대로 유지
            }
        }
        lhMatcher.appendTail(lhBuffer);
        processed = lhBuffer.toString();

        // 2. 이미지 src 경로 수정: src="upload/xxx" → src="https://itsm.youngone.com//upload/xxx"
        String OLM_SERVER_URL = StringUtil.checkNull(GlobalVal.OLM_SERVER_URL);
        processed = processed.replaceAll(
            "src=[\"']?upload/",
            "src=\""+OLM_SERVER_URL+"/custom/upload/"
        );
        
        processed = processed.replaceAll(
                "src=[\"']?/?cmm/",
                "src=\""+OLM_SERVER_URL+"/cmm/"
        );
        
        return processed;
	}
	
	//  전자 결재 그룹웨어 전송	
	public Map<String, Object> sendToGroupware(Map<String, Object> wfData) throws Exception {
		Map<String, Object> sendResult = new HashMap<>();
		try {
	        String postData = "olmI=" + URLEncoder.encode(StringUtil.checkNull(wfData.get("olmI")), "UTF-8") +
	                  "&companyCode=" + URLEncoder.encode(StringUtil.checkNull(wfData.get("companyCode")), "UTF-8") +
	                  "&teamCode=" + URLEncoder.encode(StringUtil.checkNull(wfData.get("teamCode")), "UTF-8") +
	                  "&wfInstanceID=" + URLEncoder.encode(StringUtil.checkNull(wfData.get("wfInstanceID")), "UTF-8") +
	                  "&wfFormID=" + URLEncoder.encode(StringUtil.checkNull(wfData.get("wfFormID")), "UTF-8") +
	                  "&subject=" + URLEncoder.encode(StringUtil.checkNull(wfData.get("subject")), "UTF-8") +
	                  "&bodyContext=" + URLEncoder.encode(StringUtil.checkNull(wfData.get("bodyContext")), "UTF-8");
	
	        // 1. HTTP POST 요청 설정
	        String gwUrl = StringUtil.checkNull(wfData.get("gwUrl")); // https://gw.youngonedev.com/approval/legacy/goFormLinkItsm.do // 개발
	        System.out.println("gwUrl :"+gwUrl);
	        System.out.println("postData :"+postData);
	    
	        URL url = new URL(gwUrl);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        System.out.println("▶ URL 연결 실행");
	        
	        conn.setConnectTimeout(5000); // 연결 타임아웃 (ms) - 10초
	        conn.setReadTimeout(5000);    // 응답 대기 타임아웃 (ms) - 10초

	        conn.setRequestMethod("POST");
	        conn.setDoOutput(true);
	        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	        
	        System.out.println("▶ OutputStream 열기 전"); // 확인용 로그
	
	        try (OutputStream os = conn.getOutputStream()) {
	        	System.out.println("▶ OutputStream 열림"); // 연결 여부 확인
	        	
	            os.write(postData.getBytes(StandardCharsets.UTF_8));  // postData → HTTP body로 전송됨
	            os.flush();
	            System.out.println("데이터 전송 완료");
	            
	            int responseCode = conn.getResponseCode();
		        System.out.println("Response Code: " + responseCode);
		        sendResult.put("sendResult", "정상("+responseCode+")"); //전자결재 승인 요청이 완료 
		        sendResult.put("success", true); //전자결재 승인 요청이 완료 
		        
	        }
        } catch (IOException ioe) {
            System.err.println("❌ 전송 실패: " + ioe.getMessage());
            ioe.printStackTrace(); // 원인 분석을 위한 상세 로그
            sendResult.put("sendResult", "send CNN ERR"); //전자결재 승인 요청이 완료 
            sendResult.put("success", false);
            return sendResult;
        }
        
        return sendResult;
    }
	
	private void rollbackWfInstance(String wfInstanceID) {
	    try {
	        if (wfInstanceID == null || wfInstanceID.isEmpty()) {
	            System.err.println("❌ wfInstanceID가 비어 있어 롤백 불가");
	            return;
	        }
	        Map<String, String> setData = new HashMap();
	        setData.put("wfInstanceID", wfInstanceID);
	        // 1. TB_WF_STEP_INST
	        commonService.delete("wf_SQL.deleteWFStepInst", setData);

	        // 2. TB_WF_INST_TXT
	        commonService.delete("wf_SQL.deleteWFInstTxt", setData);

	        // 3. TB_WF_INST
	        commonService.delete("wf_SQL.deleteWFInst", setData);

	        // 4. Activity wfInstanceID 초기화
	        setData.put("wfInstanceID", wfInstanceID);
	        commonService.delete("esm_SQL.updateWfInstanceNull", setData);

	        System.out.println("✅ 전자결재 롤백 처리 완료: wfInstanceID = " + wfInstanceID);

	    } catch (Exception e) {
	        System.err.println("❌ 전자결재 롤백 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    }
	}
	
	@RequestMapping(value = "/zYO_viewWfDeatil.do")
	public String zYO_viewWfDeatil(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		List attachFileList = new ArrayList();
		List wfInstList = new ArrayList();
		List wfRefInstList = new ArrayList();
		String url = "/custom/youngone/itsm/approvalDetail_SR";
		try {
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID")); // activityLogID
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
				String actorID = StringUtil.checkNull(commandMap.get("actorID"));
				String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
				String inhouse = StringUtil.checkNull(commandMap.get("inhouse"));
				
				model.put("wfDocType",wfDocType);		
				
				setMap.put("WFStepIDs", "'AREQ','APRV'");
				setMap.put("wfInstanceID", wfInstanceID);
				setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
				List wfStepInstList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);	
				Map wfInstInfo = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
			
				String Description = StringUtil.checkNull(wfInstInfo.get("Description"),"");
				Description = StringUtil.replaceFilterString(Description);
				wfInstInfo.put("Description", Description);	

				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
				model.put("wfInstInfo",wfInstInfo);			
				
				String wfStepInstInfo = "";
				String afterSeq = "";
				Map wfStepInstInfoMap = new HashMap();
				if(wfStepInstList.size() > 0 ){
					for(int i=0; i<wfStepInstList.size(); i++){
						wfStepInstInfoMap = (Map) wfStepInstList.get(i);
						if(i==0){
							wfStepInstInfo = wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
							afterSeq =  wfStepInstInfoMap.get("Seq").toString();
						}else{						
							if(wfStepInstInfoMap.get("Seq").equals(wfInstInfo.get("CurSeq"))){
								if(afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
									wfStepInstInfo = wfStepInstInfo + ", "+ "<span style='color:blue;font-weight:bold'>"+wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+") </span>";
								else
									wfStepInstInfo = wfStepInstInfo + " >> "+ "<span style='color:blue;font-weight:bold'>"+wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+") </span>";
								
							}else{
								if(afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
									wfStepInstInfo = wfStepInstInfo + ", "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
								else
									wfStepInstInfo = wfStepInstInfo + " >> "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
							}
							afterSeq = wfStepInstInfoMap.get("Seq").toString();
						}
						if(actorID.equals(wfStepInstInfoMap.get("ActorID").toString())) {
							model.put("actorWFStepName",wfStepInstInfoMap.get("WFStepName"));
							String transYN = commonService.selectString("wf_SQL.getApprTransYN", wfStepInstInfoMap);
							model.put("transYN",transYN);
						}
					}
					model.put("wfStepInstInfo", wfStepInstInfo); // 결재선
				}
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", projectID);
				Map getPJTMap = new HashMap();

				setMap.put("itemID", projectID);
				setMap.put("DocCategory", wfInstInfo.get("DocCategory"));
				setMap.put("DocumentID", commandMap.get("documentID"));
				
				
				Map getSRInfoMap = new HashMap();
				setMap.put("srCode", StringUtil.checkNull(commandMap.get("documentNo")));
				String srID = commonService.selectString("esm_SQL.getSRID", setMap);
				setMap.put("srID", srID);
					
				getSRInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);	
				String srDescription = StringUtil.replaceFilterString(StringUtil.checkNull(getSRInfoMap.get("Description")));
				getSRInfoMap.put("Description", srDescription);
				attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
				model.put("getSRInfoMap", getSRInfoMap);
				
				setMap.put("category", "DOCCAT");
				setMap.put("typeCode", wfInstInfo.get("DocCategory"));
				
				getPJTMap.put("WFDocType",StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap)));
				
				Description = StringUtil.checkNull(getPJTMap.get("Description"),"");
				Description = StringUtil.replaceFilterString(Description);
				getPJTMap.put("Description", Description);	
				model.put("getPJTMap", getPJTMap);				
				
				setMap.put("WFStepIDs", "'AREQ','APRV'");
				setMap.put("WFStepID", "");
				
				String wfPath = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFPath", setMap));
				if(!wfPath.equals(""))
				// wfInstList = getWFPathList(wfPath); // 결재라인  있을시 설정

				//String wfURL = commonService.selectString("wf_SQL.getWFCategoryURL", setMap);	
				
				setMap.put("emailCode", commandMap.get("emailCode") );
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
				
				// 진행이력 정보 				
				setMap.put("activityLogID", commandMap.get("documentID"));
				Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setMap);
				model.put("activityLogInfo", activityLogInfo);
				
				model.put("emailHTMLForm", emailHTMLForm);				
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				model.put("wfInstanceID", wfInstanceID);
				model.put("projectID", projectID);
				//model.put("wfURL", wfURL);
				model.put("wfID", wfID);
				model.put("srID", srID);
				model.put("stepInstID", stepInstID);
				model.put("actorID", actorID);
				model.put("stepSeq", stepSeq);
				model.put("wfInstanceID", wfInstanceID);
				model.put("wfDocType", wfInstInfo.get("DocCategory"));
				model.put("wfMode", StringUtil.checkNull(commandMap.get("wfMode")));
				model.put("lastSeq", lastSeq);
				model.put("screenType", commandMap.get("screenType"));
				model.put("fileList", attachFileList);
				model.put("filePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("wfInstList", wfInstList);
				model.put("wfRefInstList",wfRefInstList);
				model.put("documentID", documentID);
				model.put("docCategory", wfInstInfo.get("DocCategory"));
				model.put("inhouse", inhouse);
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	// http://weclickdev.daelim.co.kr:8090/custom/zYO_AprvProcessing.do?wfInstanceID=OLM0000000004&olml=1&companyCode=YOK&teamCode=T00001&approveStatus=4
	
	// http://weclickdev.daelim.co.kr:8090/custom/zYO_AprvProcessing.do?formID=680&mode=PROCESS&approveStatus=2&formInstanceId=504242 //상신
	// http://weclickdev.daelim.co.kr:8090/custom/zYO_AprvProcessing.do?formID=680&mode=COMPLETE&approveStatus=4&formInstanceId=504243&olmI=1020210025&companyCode=CO2_KEPZ&teamCode=H00008_1000 //승인
	
	
	//http://localhost/custom/zYO_AprvProcessing.do?formID=680&mode=PROCESS&approveStatus=T&formInstanceId=505087&olmI=2023110101&companyCode=1000&teamCode=H99999_1000&legacyID=OLM0000000722
	// 그룹웨어 전자결재에서 상태값 리턴 
	@RequestMapping({"/custom/zYO_AprvProcessing.do"})	
	public void zYO_AprvProcessing(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception { 
		System.out.println(" /custom/zYO_AprvProcessing :: Status value received");	
    	Map setData = new HashMap();
    	try {
    			dumpAllParamsForDebug(request); // Log Parameter
    			
	            String formInstanceId = StringUtil.checkNull(request.getParameter("formInstanceId"));
	    	    String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID")); // 임시저장일대만 영원전자결재에서 파라미터로 전달해줌
	    	    String olmI = StringUtil.checkNull(request.getParameter("olmI"));
	            String companyCode = StringUtil.checkNull(request.getParameter("companyCode"));
	            String teamCode = StringUtil.checkNull(request.getParameter("teamCode"));
	            String approveStatus = StringUtil.checkNull(request.getParameter("approveStatus"));
	    	    String languageID = StringUtil.checkNull(request.getParameter("languageID"));
	    	    String processID = StringUtil.checkNull(request.getParameter("processID"));
	    	    String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
	    	    
	    	    // ========================= [추가] 일괄 삭제 빠른 분기 =========================
    	        // 삭제(D) And isMulti (Y)
    	        if ("D".equals(approveStatus) && "Y".equals(isMulti)) {
    	            //List<String> wfIds = extractWfIds(request);
    	            //System.out.println("wfIds :"+wfIds);
    	            processBulkDelete(request);
    	            
    	            Map<String, String> responseMap = new HashMap<>();
        			String resMsg  = "S";
        	        responseMap.put("ReturnCode", resMsg); // resMsg 값 그대로 추가

        	        ObjectMapper objectMapper = new ObjectMapper();
        	        String jsonResponse = objectMapper.writeValueAsString(responseMap);
        	        
        	        response.setHeader("Cache-Control", "no-cache");
        		    response.setContentType("text/plain");
        		    response.setCharacterEncoding("UTF-8");
        		    
        		    response.getWriter().print(jsonResponse);
        		    
    	            return; // 단건 로직으로 내려가지 않음
    	        }
    	        // =========================================================================
	    	    
	    	    if(olmI.equals("")) {
	    	    	 olmI = StringUtil.checkNull(request.getParameter("userCode"));
	    	    }
	    	    
	    	    if (languageID == null || languageID.trim().isEmpty()) {
	    	        languageID = "1042";
	    	    }
    			
	    	    setData.put("teamCode", teamCode);
	    	    String teamID = commonService.selectString("organization_SQL.getTeamIDFromTeamCode", setData); // getTeamIDFromTeamCode
	    	    setData.put("teamCode", companyCode);
	    	    String companyID =  commonService.selectString("organization_SQL.getTeamIDFromTeamCode", setData); // getTeamIDFromTeamCode
	    	    
	    	    if(!wfInstanceID.equals("")) {
	    	    	setData.put("WFInstanceID", wfInstanceID);
	    	    // } else if(!formInstanceId.equals("")){ setData.put("returnValue", formInstanceId); 
	    	    } else {
	    	    	System.out.println("YoungoneActionController :: /custom/zDlm_AprvProcessing.do  [ wfInstanceID :"+ wfInstanceID + ",formInstanceId :"+formInstanceId + "]" );	
	    	    	wfInstanceID = StringUtil.checkNull(request.getParameter("legacyID")); // 상신부터는 wfInstanceID -> lagacyID로 넘어옴
	    	    	
	    	    	System.out.println("YoungoneActionController :: /custom/zDlm_AprvProcessing.do  [ wfInstanceID :"+ wfInstanceID + ",legacyID :"+StringUtil.checkNull(request.getParameter("legacyID")) + "]" );	
	    	    	setData.put("WFInstanceID", wfInstanceID);
	    	    }
	    	    
    			Map wfInstanceInfo = commonService.select("wf_SQL.getWFINSTanceInfo", setData);
    			
    			String wfStatus = StringUtil.checkNull(wfInstanceInfo.get("Status"));
    			
    			setData.put("returnValue", formInstanceId); 
    			wfInstanceID = StringUtil.checkNull(wfInstanceInfo.get("WFInstanceID"));			
    			String srCode = StringUtil.checkNull(wfInstanceInfo.get("DocumentNo"));
    		    setData.put("srCode", srCode);			
    			String srID = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRID", setData));
    			String activityLogID = StringUtil.checkNull(wfInstanceInfo.get("DocumentID"));
    			
    			setData.put("srID", srID);
    			setData.put("languageID", languageID);
    			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData); 
    			    			
    			setData.put("wfID", StringUtil.checkNull(wfInstanceInfo.get("WFID")));
    			setData.put("wfDocType", StringUtil.checkNull(wfInstanceInfo.get("DocCategory")));
    			// setData.put("docSubClass", StringUtil.checkNull(srInfo.get("Status")));
    			setData.put("activityLogID", activityLogID);
    			String speCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getActivitySpeCode", setData));
    			setData.put("docSubClass",speCode);
    			String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setData));
    			    			
    			// wfStatus = 2(승인) or 3(반려) ==> 상태값 update 되지 않도록
    			if ("2".equals(wfStatus) || "3".equals(wfStatus)) {
    			    System.out.println("Skip update wfStatus= (승인/반려 상태) : itsm wf satatu :" + wfStatus +", YOH approveStatus : "+approveStatus);
    			    return;
    			}
    			
    			// 임시저장(T), 상신(2), 승인(4), 반려(R), 삭제(D), 회수(임시저장)(C), 회수(상신)(2)
    		    String status = "";
    		    String approveYN = "";  // postprocessing param
    		    if(approveStatus.equals("T")) { // 임시저장
    		    	status = "0"; // 편집중
    		    	approveYN = "T";
    		    	
    		    } else if(approveStatus.equals("2")) { // 상신, 회수(상신)
    				status = "1"; // 상신 
    				approveYN = "P";
    				
    		    } else if(approveStatus.equals("4")) { // 승인
    				status = "2"; // 완료(승인)
    				approveYN = "Y";
    				
    			} else if(approveStatus.equals("R")){ // 반려
    				status = "3"; // 반려(반송)
    				approveYN = "R";
    				
    			} else if(approveStatus.equals("C")){ //회수(임시저장)(C)
    				status = "4"; 
    				approveYN = "C";
    			} else if(approveStatus.equals("D")){ // 삭제     			
    				status = "-1";    		
    				approveYN = "D";
    				// 삭제 시 재상신으로 로그상태 변경
    				setData.put("PID", srID);
    				setData.put("activityStatus", "10"); // 재상신
    				setData.put("activityLogID", activityLogID);
					Map setActivityLogMapRst = (Map)ESPUtil.updateActivityLog(request, commonService, setData);
    				
    			} 
    		 
    		    setData.put("empNo", olmI);    
    		    setData.put("teamID", teamID);    
    		    setData.put("companyID", companyID);    
    		    String lastSigner = StringUtil.checkNull(commonService.selectString("user_SQL.getMemberIDByEmpNo", setData));
    			setData.put("Status", status);
    			setData.put("WFInstanceID", wfInstanceID);
    			
    			setData.put("LastUser",  lastSigner);
    			setData.put("LastSigner", lastSigner); 
    			setData.put("ActorID", lastSigner); 
    			setData.put("ReturnedValue", formInstanceId);
    			setData.put("gwProcessID", processID);
    			
    			System.out.println("formInstanceId :"+formInstanceId);
    			System.out.println("wfInstanceID :"+wfInstanceID);
    			System.out.println("status :"+status);
    			
    			// update wf_inst 
    			commonService.update("wf_SQL.updateWfInst", setData);
    			commonService.update("wf_SQL.updateWFStepInst", setData);
    	
    			
    			Map<String, String> responseMap = new HashMap<>();
    			String resMsg  = "S";
    	        responseMap.put("ReturnCode", resMsg); // resMsg 값 그대로 추가

    	        ObjectMapper objectMapper = new ObjectMapper();
    	        String jsonResponse = objectMapper.writeValueAsString(responseMap);
    	        
    	        response.setHeader("Cache-Control", "no-cache");
    		    response.setContentType("text/json");
    		    response.setCharacterEncoding("UTF-8");
    		    
    		    response.getWriter().print(jsonResponse);
    		    response.getWriter().flush();  
    		    //response.getWriter().close(); // 역기서 끊어 줘야  영원무역 그룹웨어에서 404 오류 발생 방지됨
    		    
    		    /*
    		    if(!postProcessing.equals("")) { // /custom/srAprvProcessing.do
    				// session 정보 강제 생성( 메일보낼때 xboltController쪽에서 session에 loginInfo 정보사용해야 해서 )
    				HttpSession session = request.getSession(true);
    				Map loginInfo = (Map)session.getAttribute("loginInfo");
    				if (loginInfo == null) {
    				    loginInfo = new HashMap(); // 새 Map 생성
    				    session.setAttribute("loginInfo", loginInfo); // 세션에 다시 등록
    				}

    				// 값 주입
    				loginInfo.put("sessionUserId", StringUtil.checkNull(wfInstanceInfo.get("Creator")));      
    				loginInfo.put("sessionCurrLangType", "1042");           
    				    				
    				String data = "curWFInstanceID="+wfInstanceID+"&srID="+srID+"&roleType="+StringUtil.checkNull(srInfo.get("ProcRoleTP"))
    							+ "&languageID="+languageID+"&lastUser="+StringUtil.checkNull(wfInstanceInfo.get("Creator"))+"&activityLogID="+activityLogID
    							+ "&sessionUserId="+StringUtil.checkNull(wfInstanceInfo.get("Creator"))+"&approveYN="+approveYN;
    				postProcessing += "?" + data;
    				System.out.println("postProcessing :"+postProcessing);
    				
    				
    				// response.sendRedirect(postProcessing);  //GW 전자결재 404 영향으로 
    				RequestDispatcher dispatcher = request.getRequestDispatcher("/custom/srAprvProcessing.do?" + data);
    			    dispatcher.forward(request, response);
    			    return;
    			}
    			*/
    		    
    		    if (postProcessing != null && !postProcessing.isEmpty()) {
    		    	String INTERNAL_SERVER_URL = StringUtil.checkNull(YoungOneGlobalVal.INTERNAL_SERVER_URL);  //StringUtil.checkNull(YoungOneGlobalVal.INTERNAL_SERVER_URL); // "http://weclickdev.daelim.co.kr:8090"; 
    		        String data = "curWFInstanceID=" + wfInstanceID +
		                      "&srID=" + srID +
		                      "&roleType=" + StringUtil.checkNull(srInfo.get("ProcRoleTP")) +
		                      "&languageID=" + languageID +
		                      "&lastUser=" + StringUtil.checkNull(wfInstanceInfo.get("Creator")) +
		                      "&activityLogID=" + activityLogID +
		                      "&sessionUserId=" + StringUtil.checkNull(wfInstanceInfo.get("Creator")) +
		                      "&approveYN=" + approveYN +
		                      "&postProcessing="+postProcessing; 
    		        
    		        String finalPostUrl = INTERNAL_SERVER_URL + "custom/zYO_postProcessing.do?" + data;
    		        // 별도 스레드에서 실행
    		        ExecutorService executor = Executors.newSingleThreadExecutor();
    		        executor.submit(() -> {
    		            try {
    		            	System.out.println("post processing 내부호출 Url : "+finalPostUrl);
    		                URL url = new URL(finalPostUrl); 
    		                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    		                conn.setRequestMethod("GET");
    		                conn.setConnectTimeout(3000);  // 타임아웃 설정
    		                conn.setReadTimeout(3000);
    		               
    		                int responseCode = conn.getResponseCode();
    		                System.out.println("[POST-PROCESSING] 요청 완료. 응답코드: " + responseCode);  
    		            } catch (Exception e) {
    		                System.err.println("[POST-PROCESSING] 내부 호출 실패: " + e.getMessage());
    		            }
    		        });
    		        executor.shutdown();
    		    }
    	}catch (Exception e){	    
	    	System.out.println("YoungoneActionController :: /custom/zDlm_AprvProcessing.do ERROR :"+ e);	
	    	Map<String, String> responseMap = new HashMap<>();
			String resMsg  = "S";
	        responseMap.put("ReturnCode", resMsg); // resMsg 값 그대로 추가

	        ObjectMapper objectMapper = new ObjectMapper();
	        String jsonResponse = objectMapper.writeValueAsString(responseMap);
	        
	        response.setHeader("Cache-Control", "no-cache");
		    response.setContentType("text/json");
		    response.setCharacterEncoding("UTF-8");
		    
		    response.getWriter().print(jsonResponse);
	    }
	} 
	
	@RequestMapping({"/custom/zYO_postProcessing.do"})	
	public void zYO_postProcessing(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception { 
		System.out.println(" /custom/zYO_postProcessing 내부호출 성공");	
		dumpAllParamsForDebug(request); // Log Parameter
		try {
			// session 정보 강제 생성( 메일보낼때 xboltController쪽에서 session에 loginInfo 정보사용해야 해서 )
			HttpSession session = request.getSession(true);
			Map loginInfo = (Map)session.getAttribute("loginInfo");
			if (loginInfo == null) {
			    loginInfo = new HashMap(); // 새 Map 생성
			    session.setAttribute("loginInfo", loginInfo); // 세션에 다시 등록
			}
			
			loginInfo.put("sessionUserId", StringUtil.checkNull(request.getParameter("lastUser"))); 
		    loginInfo.put("sessionCurrLangType", StringUtil.checkNull(request.getParameter("languageID")));
	
		    String forwardData = "curWFInstanceID=" + StringUtil.checkNull(request.getParameter("wfInstanceID")) +
		                          "&srID=" + StringUtil.checkNull(request.getParameter("srID")) +
		                          "&roleType=" + StringUtil.checkNull(request.getParameter("roleType")) +
		                          "&languageID=" + StringUtil.checkNull(request.getParameter("languageID")) +
		                          "&lastUser=" + StringUtil.checkNull(request.getParameter("lastUser")) +
		                          "&activityLogID=" + StringUtil.checkNull(request.getParameter("activityLogID")) +
		                          "&sessionUserId=" + StringUtil.checkNull(request.getParameter("lastUser")) +
		                          "&approveYN=" + StringUtil.checkNull(request.getParameter("approveYN"));
	
		    RequestDispatcher dispatcher = request.getRequestDispatcher("/custom/srAprvProcessing.do?" + forwardData);
		    dispatcher.forward(request, response);
	    
		} catch (Exception e) {
	        System.err.println("[zYO_postProcessing] 실패: " + e.getMessage());
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().print("error");
	    }
	}
	
	// Log Parameter
	private void dumpAllParamsForDebug(HttpServletRequest request) {
	    Enumeration<String> names = request.getParameterNames();
	    while (names.hasMoreElements()) {
	        String k = names.nextElement();
	        System.out.println(k + ": " + request.getParameter(k));
	    }
	}

	// 일괄 삭제 처리 
	private void processBulkDelete(HttpServletRequest request) throws Exception {
		/** 파라미터 정보 
		1.approveStatus=D
		2.olmI 
		3.companyCode
		4.teamCode 
		5.formInstanceId 배열
		6. isMulti=Y (단건일때는 없음) */

	    String olmI        = StringUtil.checkNull(request.getParameter("olmI"));
	    if (olmI.isEmpty()) olmI = StringUtil.checkNull(request.getParameter("userCode"));
	    String companyCode = StringUtil.checkNull(request.getParameter("companyCode"));
	    String teamCode    = StringUtil.checkNull(request.getParameter("teamCode"));
	    String formInstanceIdList = StringUtil.checkNull(request.getParameter("formInstanceId"));

	    Map tmp = new HashMap();
	    tmp.put("teamCode", teamCode);
	    String teamID = commonService.selectString("organization_SQL.getTeamIDFromTeamCode", tmp);
	    tmp.put("teamCode", companyCode);
	    String companyID = commonService.selectString("organization_SQL.getTeamIDFromTeamCode", tmp);

	    Map idMap = new HashMap();
	    idMap.put("empNo", olmI);
	    idMap.put("teamID", teamID);
	    idMap.put("companyID", companyID);
	    String lastSigner = StringUtil.checkNull(commonService.selectString("user_SQL.getMemberIDByEmpNo", idMap));

	    List<Map<String,Object>> results = new ArrayList<>();
	    
	    String formInstacneId = "";
	    String[] ids = formInstanceIdList.split(",");
	    for (String id : ids) {
	        try {
	        	formInstacneId= id.trim();
	        	
	        	Map setData = new HashMap();
	        	setData.put("returnValue", formInstacneId);
	        	

	            Map wfInst = commonService.select("wf_SQL.getWFINSTanceInfo", setData);
	            if (wfInst == null || wfInst.isEmpty()) {
	                System.out.println( formInstacneId +" : wfInst not found");
	                continue;
	            }
	            
	            String wfInstanceID  = StringUtil.checkNull(wfInst.get("WFInstanceID"));
	            String srCode        = StringUtil.checkNull(wfInst.get("DocumentNo"));
	            String activityLogID = StringUtil.checkNull(wfInst.get("DocumentID"));

	            setData.put("srCode", srCode);
	            String srID = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRID", setData));

	            // 삭제 → 재상신 로그로 변경
	            setData.put("srID", srID);
	            setData.put("activityStatus", "10"); // 재상신
	            setData.put("activityLogID", activityLogID);
	            ESPUtil.updateActivityLog(request, commonService, setData);

	            // wf_inst / wf_step_inst 상태 업데이트 (삭제: -1)
	            setData.put("Status", "-1");
	            setData.put("WFInstanceID", wfInstanceID);
	            setData.put("LastUser",  lastSigner);
	            setData.put("LastSigner",lastSigner);
	            setData.put("ActorID",   lastSigner);

	            commonService.update("wf_SQL.updateWfInst", setData);
	            commonService.update("wf_SQL.updateWFStepInst", setData);
	        	
	        	
	        } catch (NumberFormatException e) {
	            // 숫자가 아닌 값은 무시 (또는 에러 처리)
	        	System.out.println("error formInstanceId 가 이상함 id :"+id.trim());
	        }
	    }
	    
	    System.out.println("END bult Delete ids : "+ids.length);
	}
	
	@RequestMapping(value="/zYO_viewMyInfo.do")
	public String zYO_viewMyInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			model.put("memberID", userID);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			Map setMap = new HashMap();
			setMap.put("MemberID", userID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			model.put("getData", commonService.select("user_SQL.selectUser", setMap));
			
			model.put("teamTypeYN", StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl("custom/youngone/itsm/user/zYO_viewMyInfo");
	}



	
}