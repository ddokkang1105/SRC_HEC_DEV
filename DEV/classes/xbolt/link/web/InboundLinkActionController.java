package xbolt.link.web;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import net.sf.json.JSONArray;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.api.enumType.ResponseCode;
import xbolt.api.response.ApiResponse;
import xbolt.api.util.RestApiUtil;

@RestController //Controller 라는 것을 명시 @Controller + @RequestBody 

@CrossOrigin(origins = "*", allowedHeaders = "*")
public class InboundLinkActionController extends XboltController{
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;

	// 외부시스템에서 OLM ITEM 호출 Test Index 화면 
	@RequestMapping(value="/olmLinkTest.do")
	public String olmLinkTest(Map cmmMap,ModelMap model) throws Exception {
		//String pass = URLDecoder.decode(StringUtil.checkNull(cmmMap.get("olmP")), "UTF-8");
		String pass = StringUtil.checkNull(cmmMap.get("olmP"));
		model.put("olmI", StringUtil.checkNull(cmmMap.get("olmI"),""));
		model.put("olmP", pass);
		model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
		Map setMap = new HashMap();
		 
		//setMap.put("flowID", "'4000'");
		//List resultData = commonService.selectList("link_SQL.getTestOpenQuery", setMap);
		//System.out.println("resultData :"+resultData);
		return nextUrl("olmLinkTest");
	}
		
	// 외부시스템에서 OLM Item 호출 
	@RequestMapping(value="/olmLink.do")
	public String olmLinkPopup(Map cmmMap,ModelMap model) throws Exception {
		String url = "/template/olmLinkPopup";
		String loginid = StringUtil.checkNull(cmmMap.get("olmLoginid"));
		String languageID = StringUtil.checkNull(cmmMap.get("languageID"));
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;		
		model.put("loginid", loginid);
		model.put("languageID", languageID);
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		System.out.println("***olmLinkPopup::"+url+"???loginid="+loginid);
		return nextUrl(url);
	}
	
	// 외부시스템에서 OLM Item 호출 
	@PostMapping(value="/olmObjLink.do")
	public String olmLinkPost(Map cmmMap,ModelMap model) throws Exception {
		String url = "/template/olmObjLinkPop";
		String loginid = StringUtil.checkNull(cmmMap.get("olmLoginid"));
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;		
		model.put("loginid", loginid);
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		model.put("olmLinkData", cmmMap);
		System.out.println("***olmLinkPopup::"+url+"???loginid="+loginid);
		return nextUrl(url);
	}
	
	// 외부시스템에서 OLM Item 호출 
	@RequestMapping(value="/olmChangeSetLink.do")
	public String olmChangeSetLink(Map cmmMap,ModelMap model) throws Exception {
		String url = "/project/changeInfo/olmChangeSetLink";
		String loginid = StringUtil.checkNull(cmmMap.get("olmLoginid"));
		String itemID = StringUtil.checkNull(cmmMap.get("keyID"));
		String changeSetID = StringUtil.checkNull(cmmMap.get("linkID"));
		String languageID = StringUtil.checkNull(cmmMap.get("languageID"));
		String arCode = "";
		Map setMap = new HashMap();
		setMap.put("changeSetID", changeSetID);
		//Map csMap = commonService.select("cs_SQL.getChangeInfo", setMap);
		String changeType = StringUtil.checkNull(commonService.selectString("cs_SQL.getChangeType", setMap));
		
		setMap.put("itemID", itemID);
		String maxVersion = commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
		
		if(changeType.equals("MOD")) {
			arCode = "AR000004";			
		}
		else {
			arCode = "AR000004A";			
		}

		model.put("itemID", itemID);
		model.put("changeSetID", changeSetID);
		model.put("arCode", arCode);
		model.put("loginid", loginid);
		model.put("languageID", languageID);
		return nextUrl(url);
	}
	
	

	// 외부시스템에서 OLM Item 호출 
	@RequestMapping(value="/olmAprvDueLink.do")
	public String olmAprvDueLink(Map cmmMap,ModelMap model) throws Exception {
		String url = "/wf/olmAprvDueLinkPopup";
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		
		Map setData = new HashMap();
		Map userInfo = new HashMap();
		
		String empNo = StringUtil.checkNull(cmmMap.get("empNo"),"");
		String langCode = StringUtil.checkNull(cmmMap.get("language"),"");
		
		setData.put("extCode", langCode);
		langCode = commonService.selectString("common_SQL.getLanguageID", setData);
				
		setData.put("employeeNum", empNo);

		if(empNo != null && !empNo.isEmpty()) {
			userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
		}
		
		if(userInfo != null && !userInfo.isEmpty()) {
			model.put("loginid", StringUtil.checkNull(userInfo.get("LoginId")));
		}
		
		model.put("languageID", langCode);
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		System.out.println("***olmLinkPopup::"+url+"???empNo="+empNo);
		return nextUrl(url);
	}
	
	@RequestMapping(value="/olmLinkArc.do")
	public String olmLinkArc(Map cmmMap,ModelMap model) throws Exception {
		String url = "/hom/main/arc/olmLinkArc";
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		
		String loginID = StringUtil.checkNull(cmmMap.get("loginID"),"");
		String languageID = StringUtil.checkNull(cmmMap.get("languageID"),"");
		String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"),"");
		String currArcIdx = StringUtil.checkNull(cmmMap.get("currArcIdx"),"");
		String linkID = StringUtil.checkNull(cmmMap.get("linkID"));
		String itemTypeCode = StringUtil.checkNull(cmmMap.get("itemTypeCode"));
		String linkType = StringUtil.checkNull(cmmMap.get("linkType"));
		
		model.put("loginid", loginID);		
		model.put("languageID", languageID);
		model.put("arcCode", arcCode);
		model.put("currArcIdx", currArcIdx);
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		model.put("linkID", linkID);
		model.put("itemTypeCode", itemTypeCode);
		model.put("linkType", linkType);
		
		//System.out.println("***olmLinkArc::"+url+"???loginID="+loginID);
		return nextUrl(url);
	}
	 
	@RequestMapping(value="/olmLinkMaster.do")
	public String olmLinkMaster(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		String url = "/hom/main/olmLinkMaster";
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
				
		String languageID = StringUtil.checkNull(cmmMap.get("languageID"),"");
		String mainType = StringUtil.checkNull(cmmMap.get("mainType"),"");
		String srID = StringUtil.checkNull(cmmMap.get("srID"),"");
		String wfInstanceID = StringUtil.checkNull(cmmMap.get("wfInstanceID"),"");
			
		model.put("languageID", languageID);
		model.put("mainType", mainType);
		model.put("srID", srID);
		model.put("wfInstanceID", wfInstanceID);
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
		
		return nextUrl(url);
	}
	
	
	
	
	/*
	 * 2025-05-30
	 * 
	 * Z_PAL_DEPT
	 * 
	 * JSON ARRAY INSERT TABLE TEST
	 * 
	 * 작성자 : KGY
	 */
	@RequestMapping(value = "/palDeptTest.do")
	 public String palDeptTestPage(ModelMap model, HttpServletRequest request) throws Exception {
		  return nextUrl("palDeptTest");
	}
	
	@RequestMapping(value = "/olmPalDept.do", method=RequestMethod.POST, consumes = "application/json; charset=utf-8", produces = "application/json; charset=utf-8")
	 public void olmPalDept(@RequestBody String requestJsonArray, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ApiResponse<?> apiResponse = null;
	    ObjectMapper objectMapper = new ObjectMapper();
		
		try {
			
	        // JSON 배열을 List<Map<String, Object>>로 변환
	        List<Map<String, Object>> dataList = objectMapper.readValue(requestJsonArray, new TypeReference<List<Map<String, Object>>>() {});

	        for (Map<String, Object> setMap : dataList) {
	            commonService.insert("custom_SQL.zDLMC_insertDept", setMap);
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
	
	
}