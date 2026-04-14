package xbolt.api.web;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import net.sf.json.JSONArray;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ExtApiActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@Resource(name = "commonOraService")
	private CommonService commonOraService;
		
	

	@RequestMapping(value="/searchNhnOpenApi.do")
	public String searchNhnOpenApi(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws Exception {
		System.out.println("searchNhnOpenAPI.do.... ");
		
		String url = "/cmm/restApiTest/restOpenApiTest";
		Map target = new HashMap();	
		String clientId = "SL6ZKFuSzknFRtc4tjte"; //애플리케이션 클라이언트 아이디값"
        String clientSecret = "h_11_8946h"; //애플리케이션 클라이언트 시크릿값"
        String text = null;
        String str = StringUtil.checkNull(request.getParameter("searchValue"), "");
       
        System.out.println("str :"+str);
        try {
        	
        	if(!str.equals("")){
		        try {
		            text = URLEncoder.encode(str, "UTF-8");
		        } catch (UnsupportedEncodingException e) {
		            throw new RuntimeException("검색어 인코딩 실패",e);
		        }
		
		        String apiURL = "https://openapi.naver.com/v1/search/kin.json?query=" + text+"&display=10&start=1&sort=sim";    // json 결과
		
		        Map<String, String> requestHeaders = new HashMap<>();
		        requestHeaders.put("X-Naver-Client-Id", clientId);
		        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
		        
		        String responseBody = get(apiURL,requestHeaders) ;
		        
		        System.out.println("responseBody   : "+  responseBody );
		        
	            JSONParser parser = new JSONParser();
	            Object obj = parser.parse(responseBody);
	
	
	            JSONObject jsonObject = (JSONObject) obj;
	            JSONArray getArray = (JSONArray) jsonObject.get("items");
	            for (int i = 0; i < getArray.size(); i++) {
	                JSONObject object = (JSONObject) getArray.get(i);
	
	                String title = StringUtil.checkNull( object.get("title")).replaceAll("<b>", "").replaceAll("</b>", "");
	                String description = StringUtil.checkNull(  object.get("description")).replaceAll("<b>", "").replaceAll("</b>", "");
	                String link =  StringUtil.checkNull(  object.get("link"));
	                String orgiginallink =  StringUtil.checkNull(  object.get("orgiginallink"));
	
	                System.out.println("title :"+title);
	                System.out.println("*********************************");
	                System.out.println("description :"+description);
	                System.out.println("*********************************");
	                System.out.println("link :"+link);
	                System.out.println("*********************************");
	                System.out.println("orgiginallink :"+orgiginallink);
	                System.out.println("*********************************");
	                 
	             }
	            
	            model.put("searchResultList",  getArray);
        	}

		
        }catch (Exception e) {
			//if(_log.isInfoEnabled()){_log.info("MainActionController::menuURL::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
        
		model.addAttribute(AJAX_RESULTMAP,target);
		return nextUrl(url);
	}
	
	private static String get(String apiUrl, Map<String, String> requestHeaders){
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }
 
            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
               
            	System.out.println();
            	
            	
            	return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }
  


	// 네이버 회원 정보 조회 
	@RequestMapping(value = "/restApiGetNhnMember.do")
	public String restApiGetNhnMember(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		String token = "YOUR_ACCESS_TOKEN";// 접근 토큰 값";
        String header = "Bearer " + token; // Bearer 다음에 공백 추가
        try {
            String apiURL = "https://openapi.naver.com/v1/nid/me";
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Authorization", header);
            int responseCode = con.getResponseCode();
            
            BufferedReader br;
            if(responseCode==200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();
            System.out.println(response.toString());
        } catch (Exception e) {
            System.out.println(e);
        }
        model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
	
	// 미세먼지 정보 조회 
	@RequestMapping(value = "/restApiFineDust.do")
	public String restApiFineDust(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
        try {
        	// 인증키
            String serviceKey = "인증키값";
            
            String urlStr = "http://openapi.airkorea.or.kr/openapi/services/rest/UlfptcaAlarmInqireSvc/getUlfptcaAlarmInfo";
            urlStr += "?"+ URLEncoder.encode("ServiceKey","UTF-8") +"=" + serviceKey;
            urlStr += "&"+ URLEncoder.encode("numOfRows","UTF-8") +"=200";
            urlStr += "&"+ URLEncoder.encode("pageNo","UTF-8") +"=1";
            urlStr += "&"+ URLEncoder.encode("year","UTF-8") +"=2019";
            urlStr += "&"+ URLEncoder.encode("_returnType","UTF-8") +"=json";
            
            URL url = new URL(urlStr);
            
            String line = "";
            String result = "";
            
            BufferedReader br;
            br = new BufferedReader(new InputStreamReader(url.openStream()));
            while ((line = br.readLine()) != null) {
                result = result.concat(line);
                //System.out.println(line);                
            }            
            
            // JSON parser 만들어 문자열 데이터를 객체화한다.
            JSONParser parser = new JSONParser();
            JSONObject obj = (JSONObject)parser.parse(result);
            
            // list 아래가 배열형태로
            // {"list" : [ {"returnType":"json","clearDate":"--",.......} ] 
            JSONArray parse_listArr = (JSONArray)obj.get("list");
            
            String miseType = "";
            
            // 객체형태로
            // {"returnType":"json","clearDate":"--",.......},... 
            for (int i=0;i< parse_listArr.size();i++) {
                JSONObject weather = (JSONObject) parse_listArr.get(i);
                String dataDate = (String) weather.get("dataDate");            // 발령날짜
                String districtName = (String) weather.get("districtName");    // 발령지역
                String moveName = (String) weather.get("moveName");            // 발령권역
                String issueDate = (String) weather.get("issueDate");        // 발령일자
                String issueTime = (String) weather.get("issueTime");        // 발령시간
                String issueVal  = (String) weather.get("issueVal");        // 발령농도
                String itemCode  = (String) weather.get("itemCode");        // 미세먼지 구분 PM10, PM25
                String issueGbn  = (String) weather.get("issueGbn");        // 경보단계 : 주의보/경보
                String clearDate = (String) weather.get("clearDate");        // 해제일자
                String clearTime = (String) weather.get("clearTime");        // 해제시간
                String clearVal = (String) weather.get("clearVal");            // 해제시 미세먼지농도
                
                if (itemCode.equals("PM10")) {            
                    miseType = "";
                } else if (itemCode.equals("PM25")) {    
                    miseType = "초미세먼지";
                }
                StringBuffer sb = new StringBuffer();
                sb.append("발령날짜 : " + dataDate + ", 지역 : " + districtName + " ("+ moveName +"), " + "발령시간 : "+ issueDate + " " + issueTime + ", 농도 : " + issueVal + " ("+ issueGbn +") " + miseType);
                System.out.println(sb.toString());     
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
	
	/**
	 * 카카오
	 * */
	/*
	@RequestMapping(value="/custom/KaKaoWorkTest.do")
	public void KaKaoWorkTest(HttpServletRequest request) {
		

		String[] Emails = request.getParameterValues("email");
		List<String> emailList = Arrays.asList(Emails);

		List<Integer> userIDs = getUserInfoByEmail(emailList);
		String conversation_id = exeConversationOpen(userIDs);
		
		Map cmmMap = new HashMap();
		cmmMap.put("title", "TEST TITLE !");
		cmmMap.put("subject", "TEST subject !");
		cmmMap.put("content", "TEST content !");
		cmmMap.put("conversation_id", conversation_id);
		
		try {
			messagesSend(cmmMap);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	//@RequestMapping(value="/custom/getUserInfoByEmail.do")
	public List<Integer> getUserInfoByEmail(List<String> emailList) {
		String targetUrl = "https://api.kakaowork.com/v1/users.find_by_email?";
		String parameters = "email=";
		
		List<Integer> returnIDs = new ArrayList();

		JSONParser parser = new JSONParser();
		Object obj = new Object();
		JSONObject jsonObj = new JSONObject();
		Boolean success;
		Object obj1 = new Object();
		JSONObject jsonObj1 = new JSONObject();
		
		String result = "";
		try {
			
			if(emailList.size() > 0) {
				for(int i=0; i<emailList.size(); i++) {
					parameters = "email="+emailList.get(i);
					result = bacthActionController.sendReturnGet(targetUrl + parameters, "", tokenKey);
					obj = parser.parse( result );
					jsonObj = (JSONObject) obj;
					success = (Boolean) jsonObj.get("success");
					if(success == true) {
						obj1 = jsonObj.get("user");
						jsonObj1 = (JSONObject) obj1;
						System.out.println(jsonObj1.get("id"));
						System.out.println(jsonObj1.get("name"));
						returnIDs.add(Integer.valueOf((String) jsonObj1.get("id")));
					}
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(result);
		//{"success":true,"user":{"avatar_url":null,"department":null,"id":"2511015","mobiles":[],"name":"?씠?썑李?","nickname":null,"position":null,"responsibility":null,"space_id":"141287","tels":[],"vacation_end_time":null,"vacation_start_time":null,"work_end_time":null,"work_start_time":null}}
		return returnIDs;
	}

	public String exeConversationOpen(List<Integer> userIDs) {
		String result = "";
		String conversation_id = "";
		String targetUrl = "https://api.kakaowork.com/v1/conversations.open";
		String parameters = "{ \"user_ids\" : " + userIDs.toString() + "}";
		
		JSONParser parser = new JSONParser();
		Object obj = new Object();
		JSONObject jsonObj = new JSONObject();
		Boolean success;
		Object obj1 = new Object();
		JSONObject jsonObj1 = new JSONObject();
		
		try {
			result = bacthActionController.sendReturnPost(targetUrl, parameters, "", tokenKey);
			obj = parser.parse( result );
			jsonObj = (JSONObject) obj;
			success = (Boolean) jsonObj.get("success");
			if(success == true) {
				obj1 = jsonObj.get("conversation");
				jsonObj1 = (JSONObject) obj1;
				System.out.println(jsonObj1.get("id"));
				System.out.println(jsonObj1.get("name"));
				conversation_id = (String) jsonObj1.get("id");
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//{"conversation":{"avatar_url":null,"id":"1084977","name":"이후창, 조우진","type":"group","users_count":3},"success":true}
		return conversation_id;
	}
	
	public void  messagesSend(Map cmmMap) throws Exception {
		String targetUrl = "https://api.kakaowork.com/v1/messages.send ";
		
		String returnText = "{" + 
				"  \"title\": \"OLM 검색\"," + 
				"  \"accept\": \"검색\"," + 
				"  \"decline\": \"취소\"," + 
				"  \"value\": \"test=true\"," + 
				"  \"blocks\": [" + 
				"    {" + 
				"      \"type\": \"label\"," + 
				"      \"text\": \"검색어\"," + 
				"      \"markdown\": false" + 
				"    }," + 
				"    {" + 
				"      \"type\": \"input\"," + 
				"      \"name\": \"text_reason\"," + 
				"      \"required\": true," + 
				"      \"placeholder\": \"검색어를 입력해주세요. (최대 10자)\"" + 
				"    }" + 
				"  ]" + 
				"}";
		String parameters = "{ \"conversation_id\": \""+cmmMap.get("conversation_id")+"\", \"text\": \"Hello test.\", "
				+ "\"blocks\": [" +
				"{" + 
					" \"type\": \"header\"," + 
					" \"text\": \" "+ StringUtil.checkNull(cmmMap.get("title"), "Test title") +" \"," + 
					" \"style\": \"blue\"" + 
				" }," + 
				" {" + 
					" \"type\": \"text\"," + 
					" \"text\": \" " +
					" Subject : " + StringUtil.checkNull(cmmMap.get("subject"), "TEST subject") + 
					" Content : "+ StringUtil.checkNull(cmmMap.get("content"), "TEST Content") + " \"," + 
					" \"markdown\": true" + 
				"  }"
				+ "]"
				+ "}";
		
		System.out.println(parameters);
		bacthActionController.sendPost(targetUrl, parameters, "", tokenKey);
	}
	
	@RequestMapping(value="/custom/kakaoRequest.do")
	public void  kakaoRequest(Map cmmMap, HttpServletRequest request) throws Exception {
		
		String returnText = "{" + 
				"  \"title\": \"OLM 검색\"," + 
				"  \"accept\": \"검색\"," + 
				"  \"decline\": \"취소\"," + 
				"  \"value\": \"test=true\"," + 
				"  \"blocks\": [" + 
				"    {" + 
				"      \"type\": \"label\"," + 
				"      \"text\": \"검색어\"," + 
				"      \"markdown\": false" + 
				"    }," + 
				"    {" + 
				"      \"type\": \"input\"," + 
				"      \"name\": \"text_reason\"," + 
				"      \"required\": true," + 
				"      \"placeholder\": \"검색어를 입력해주세요. (최대 10자)\"" + 
				"    }" + 
				"  ]" + 
				"}";
		String url = "https://api.kakaowork.com/v1/messages.send ";
		String token = "ceb1473d.53a95db76acc419ab6f3976f099287fb";
		String parameters = "{ \"conversation_id\": \"1040538\", \"text\": \"Hello test.\", "
				+ "\"blocks\": [" +
				"{" + 
				"      \"type\": \"header\"," + 
				"      \"text\": \" "+ StringUtil.checkNull(cmmMap.get("title"), "Test title") +" \"," + 
				"      \"style\": \"blue\"" + 
				"    }," + 
				"    {" + 
				"      \"type\": \"text\"," + 
				"      \"text\": \" " +
				"	Subject : " + StringUtil.checkNull(cmmMap.get("subject"), "TEST subject") + "\\n" + 
				"	Content : "+ StringUtil.checkNull(cmmMap.get("content"), "TEST Content") + " \"," + 
				"      \"markdown\": true" + 
				"    }"
				+ "]"
				+ " }";
		parameters = StringEscapeUtils.unescapeHtml4(parameters);
		System.out.println(parameters);
		BacthActionController bacthActionController = new BacthActionController();
		bacthActionController.sendPost(url, parameters, "", token);
	}
	
	
	@RequestMapping(value="/custom/kakaoCallback.do")
	public ModelAndView kakaoCallback(Map cmmMap, ModelAndView mv) throws Exception {
		String returnText = "{" + 
				"  \"type\": \"submission\"," + 
				"  \"action_time\": \"{요청 액션이 발생한 카카오워크 서버의 시간 값}\"," + 
				"  \"actions\": {" + 
				"    \"text_reason\": \"qq\"" + 
				"  }," + 
				"  \"message\": \"{액션이 발생한 채팅 메시지 원본}\"," + 
				"  \"value\": \"{request_modal의 응답으로 전송한 value 값}\"" + 
				"}";
		mv.addObject("result", returnText);
	    mv.setViewName("jsonView");
		return mv;
	}*/

	// TODO : 개행 코드 삭제
	private String removeAllTag(String str) {

		str = str.replaceAll("&lt;", "<");//201610 new line :: Excel To DB 
		str = str.replaceAll("&gt;", ">");//201610 new line :: Excel To DB 
		str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-");//20161024 bshyun Test
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		return StringEscapeUtils.unescapeHtml4(str);
	}	
	/*
	 * naver papago
	 * */
	@RequestMapping(value="/getPapagoTrans.do")
	public String getPapagoTrans(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();	    
		try {
	        String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
	        String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	        String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"),"");
	        // 화면에서 드래그 하는 경우
	        String text = StringUtil.checkNull(request.getParameter("text"),"");
	        String plainText = "";
	        
	        setMap.put("itemID",itemID);
	        setMap.put("languageID", languageID);
	        setMap.put("attrTypeCode", attrTypeCode);
	        
	        if(!text.equals("")) plainText = text;
	        else plainText = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap));
	        
	        List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);
	        JSONArray activeLangList = convertListToJson(getLanguageList);
	        
        	model.put("itemID", itemID);
        	model.put("languageID", languageID);
        	model.put("attrTypeCode", attrTypeCode);
    		model.put("plainText",plainText);
    		model.put("activeLangList",activeLangList);
    		model.put("text",text);
        } catch (Exception e) {
            System.out.println(e);
        }

		return nextUrl("/itm/tran/papagoLangTran");
	}
	
	@RequestMapping(value = "/savePapagoTrans.do")
	public String saveEvalType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"));
			String tarLangCode = StringUtil.checkNull(request.getParameter("tarLangCode"));
			String translatedText = StringUtil.checkNull(request.getParameter("translatedText"));
			
			setMap.put("ItemID",itemID);
			setMap.put("AttrTypeCode",attrTypeCode);
			setMap.put("LanguageID",tarLangCode);
			setMap.put("PlainText",translatedText);
			
			commonService.update("attr_SQL.setOccInfo", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_SCRIPT, "parent.selfClose();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value="/getGPTAITrans.do")
	public String getGPTAITrans(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"),"");
			// 화면에서 드래그 하는 경우
			String text = StringUtil.checkNull(request.getParameter("text"),"");
			String plainText = "";

			setMap.put("itemID",itemID);
			setMap.put("languageID", languageID);
			setMap.put("attrTypeCode", attrTypeCode);

			if(!text.equals("")) plainText = text;
			else plainText = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap));

			List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);
			JSONArray activeLangList = convertListToJson(getLanguageList);

			model.put("itemID", itemID);
			model.put("languageID", languageID);
			model.put("attrTypeCode", attrTypeCode);
			model.put("plainText",plainText);
			model.put("activeLangList",activeLangList);
			model.put("text",text);
		} catch (Exception e) {
			System.out.println(e);
		}

		return nextUrl("/itm/tran/gptAILangTran");
	}

	public static JSONArray convertListToJson(List<Map<String, Object>> listMap) throws Exception {
	    JSONArray jsonArray = new JSONArray();
	    for (Map<String, Object> map : listMap) {
	        jsonArray.add(convertMapToJson(map));
	    }
	    return jsonArray;
	}
	
	public static JSONObject convertMapToJson(Map<String, Object> map) throws Exception {
	    JSONObject json = new JSONObject();
	    for (Map.Entry<String, Object> entry : map.entrySet()) {
	        String key = entry.getKey();
	        Object value = entry.getValue();
	        if(key.equals("PRE_TREE_ID")) key = "parent";
	        if(key.equals("TREE_ID")) key = "id";
	        if(key.equals("TREE_NM")) key = "value";
	        json.put(key, value);
	    }
	    return json;
	}
	
	@RequestMapping(value = "/olmapi/transData", method = RequestMethod.GET)
	@ResponseBody
	public void getTransData(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		String apiURL = StringUtil.checkNull(DrmGlobalVal.PAPAGO_API_URL);//애플리케이션 클라이언트 아이디값";
		JSONObject result = new JSONObject();
		Map setMap = new HashMap();
        
		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		
	    OutputStream outputStream = null;
	    BufferedReader bufferedReader = null;
	    BufferedWriter bufferedWriter = null;
	    
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	        String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"),"");
	        String sourceLang = StringUtil.checkNull(request.getParameter("sourceLang"));
	        String targetLang = StringUtil.checkNull(request.getParameter("targetLang"));
	        String memberID = StringUtil.checkNull(request.getParameter("memberID"));
	        String text = StringUtil.checkNull(request.getParameter("text"), "");
       		
	        setMap.put("itemID",itemID);
	        setMap.put("languageID", languageID);
	        setMap.put("attrTypeCode", attrTypeCode);
	        
	        String plainText = "";
	        if(!text.equals("")) plainText = text;
	        else plainText = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap));
	        
            URL url = new URL(apiURL+"/olmapi/naverTrans");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            
            JSONObject sendData = new JSONObject();
            sendData.put("source", sourceLang);
            sendData.put("target", targetLang);
            sendData.put("text", plainText);
            
            outputStream = con.getOutputStream();
            bufferedWriter = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
            bufferedWriter.write(sendData.toString());
            bufferedWriter.flush();
            
            int responseCode = con.getResponseCode();
            if(responseCode == HttpURLConnection.HTTP_OK)  { // 정상 호출
            	bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            	// 로그 TB_TRAN_API_LOG
            	setMap.put("contents",plainText);
            	setMap.put("memberID", memberID);
            	commonService.insert("gloval_SQL.insertTranLog", setMap);
            } else {  // 오류 발생
            	bufferedReader = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
            }
            
            String inputLine;
            StringBuffer res = new StringBuffer();
            while ((inputLine = bufferedReader.readLine()) != null) {
                res.append(inputLine);
            }
            
            response.getWriter().print(res.toString());
       } catch (Exception e) {
           System.out.println(e);
       } finally {
           try {
               if (bufferedWriter != null) { bufferedWriter.close(); }
               if (outputStream != null) { outputStream.close(); }
               if (bufferedReader != null) { bufferedReader.close(); }
           }  catch(Exception ex) { 
               ex.printStackTrace();
           }
       }
	}
	
	@RequestMapping(value = "/olmapi/langData", method = RequestMethod.POST)
	@ResponseBody
	public void getLangData(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		String apiURL = StringUtil.checkNull(DrmGlobalVal.PAPAGO_API_URL);//애플리케이션 클라이언트 아이디값";
		JSONObject result = new JSONObject();
		Map setMap = new HashMap();
        
		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		
	    OutputStream outputStream = null;
	    BufferedReader bufferedReader = null;
	    BufferedWriter bufferedWriter = null;
	    
		try {
	     // JSON 문자열을 Java 객체로 변환
	        ObjectMapper objectMapper = new ObjectMapper();
	        
	     // 요청 본문에서 JSON 데이터 읽기
	        StringBuilder jsonBuilder = new StringBuilder();
	        try (BufferedReader reader = request.getReader()) {
	            String line;
	            while ((line = reader.readLine()) != null) {
	                jsonBuilder.append(line);
	            }
	        }
	        String jsonString = jsonBuilder.toString();
	        System.out.println("==== jsonString ===="+jsonString);
	        
	     // jsonString을 Map 객체로 변환
	        Map<String, Object> jsonMap = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});
	        
            URL url = new URL(apiURL+"/olmapi/langDect");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            
            JSONObject sendData = new JSONObject();
            sendData.put("query", jsonMap.get("text"));
            
            outputStream = con.getOutputStream();
            bufferedWriter = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
            bufferedWriter.write(sendData.toString());
            bufferedWriter.flush();
            
            int responseCode = con.getResponseCode();
            if(responseCode == HttpURLConnection.HTTP_OK)  { // 정상 호출
            	bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            } else {  // 오류 발생
            	bufferedReader = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
            }
            
            String inputLine;
            StringBuffer res = new StringBuffer();
            while ((inputLine = bufferedReader.readLine()) != null) {
                res.append(inputLine);
            }
            
            response.getWriter().print(res.toString());
       } catch (Exception e) {
           System.out.println(e);
       } finally {
           try {
               if (bufferedWriter != null) { bufferedWriter.close(); }
               if (outputStream != null) { outputStream.close(); }
               if (bufferedReader != null) { bufferedReader.close(); }
           }  catch(Exception ex) { 
               ex.printStackTrace();
           }
       }
	}

	@RequestMapping(value = "/olmapi/transData/gptAI", method = RequestMethod.GET)
	@ResponseBody
	public void getTransDataGPTAI(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		String apiURL = StringUtil.checkNull(apiGlobalVal.GPTAI_API_URL);
		JSONObject result = new JSONObject();
		Map setMap = new HashMap();

		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");

		OutputStream outputStream = null;
		BufferedReader bufferedReader = null;
		BufferedWriter bufferedWriter = null;

		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"),"");
			String sourceLang = StringUtil.checkNull(request.getParameter("sourceLang"));
			String targetLang = StringUtil.checkNull(request.getParameter("targetLang"));
			String memberID = StringUtil.checkNull(request.getParameter("memberID"));
			String text = StringUtil.checkNull(request.getParameter("text"), "");

			setMap.put("itemID",itemID);
			setMap.put("languageID", languageID);
			setMap.put("attrTypeCode", attrTypeCode);

			String plainText = "";
			if(!text.equals("")) plainText = text;
			else plainText = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap));

			URL url = new URL(apiURL+"/api/translator/translate");
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/json");
			con.setDoOutput(true);

			JSONObject sendData = new JSONObject();
			sendData.put("text", plainText);
			sendData.put("src_lang", sourceLang);
			sendData.put("dest_lang", targetLang);

			outputStream = con.getOutputStream();
			bufferedWriter = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
			bufferedWriter.write(sendData.toString());
			bufferedWriter.flush();

			int responseCode = con.getResponseCode();
			if(responseCode == HttpURLConnection.HTTP_OK)  { // 정상 호출
				bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
				// 로그 TB_TRAN_API_LOG
				setMap.put("contents",plainText);
				setMap.put("memberID", memberID);
				commonService.insert("gloval_SQL.insertTranLog", setMap);
			} else {  // 오류 발생
				bufferedReader = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
			}

			String inputLine;
			StringBuffer res = new StringBuffer();
			while ((inputLine = bufferedReader.readLine()) != null) {
				res.append(inputLine);
			}

			String jsonStr = res.toString();

			int start = jsonStr.indexOf(":\"") + 2;
			int end = jsonStr.lastIndexOf("\"");

			String translatedText = "";
			if (start > 1 && end > start) {
				translatedText = jsonStr.substring(start, end);
			}

			response.getWriter().print(translatedText);
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			try {
				if (bufferedWriter != null) { bufferedWriter.close(); }
				if (outputStream != null) { outputStream.close(); }
				if (bufferedReader != null) { bufferedReader.close(); }
			}  catch(Exception ex) {
				ex.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/olmapi/langData/gptAI", method = RequestMethod.POST)
	@ResponseBody
	public void getLangDataGPTAI(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		String apiURL = StringUtil.checkNull(apiGlobalVal.GPTAI_API_URL);
		JSONObject result = new JSONObject();
		Map setMap = new HashMap();

		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");

		OutputStream outputStream = null;
		BufferedReader bufferedReader = null;
		BufferedWriter bufferedWriter = null;

		try {
			// JSON 문자열을 Java 객체로 변환
			ObjectMapper objectMapper = new ObjectMapper();

			// 요청 본문에서 JSON 데이터 읽기
			StringBuilder jsonBuilder = new StringBuilder();
			try (BufferedReader reader = request.getReader()) {
				String line;
				while ((line = reader.readLine()) != null) {
					jsonBuilder.append(line);
				}
			}
			String jsonString = jsonBuilder.toString();
			System.out.println("==== jsonString ===="+jsonString);

			// jsonString을 Map 객체로 변환
			Map<String, Object> jsonMap = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});

			URL url = new URL(apiURL+"/api/translator/detect-language");
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/json");
			con.setDoOutput(true);

			JSONObject sendData = new JSONObject();
			sendData.put("text", jsonMap.get("text"));

			outputStream = con.getOutputStream();
			bufferedWriter = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
			bufferedWriter.write(sendData.toString());
			bufferedWriter.flush();

			int responseCode = con.getResponseCode();
			if(responseCode == HttpURLConnection.HTTP_OK)  { // 정상 호출
				bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			} else {  // 오류 발생
				bufferedReader = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
			}

			String inputLine;
			StringBuffer res = new StringBuffer();
			while ((inputLine = bufferedReader.readLine()) != null) {
				res.append(inputLine);
			}

			String jsonStr = res.toString();

			int start = jsonStr.indexOf("\"language\":\"") + "\"language\":\"".length();
			int end = jsonStr.indexOf("\"", start);

			String detectedText = "";
			if (start > "\"language\":\"".length() - 1 && end > start) {
				detectedText = jsonStr.substring(start, end);
			}

			response.getWriter().print(detectedText);
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			try {
				if (bufferedWriter != null) { bufferedWriter.close(); }
				if (outputStream != null) { outputStream.close(); }
				if (bufferedReader != null) { bufferedReader.close(); }
			}  catch(Exception ex) {
				ex.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/olmapi/getLanguageID", method = RequestMethod.GET)
	public void getItemCSInfo(HttpServletRequest request, HttpServletResponse res) throws Exception {
		com.org.json.JSONObject jsonObject = new com.org.json.JSONObject();
		Map<String, Object> map = new HashMap<>();

		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");

		try {
			String extCode = StringUtil.checkNull(request.getParameter("ExtCode"), "");

			map.put("extCode", extCode);

			String languageID = commonService.selectString("common_SQL.getLanguageID", map);
			jsonObject.put("tarLangCode", languageID);
			res.getWriter().print(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
			res.getWriter().print(jsonObject);
		}
	}

	private static HttpURLConnection connect(String apiUrl){
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }

    private static String readBody(InputStream body){
        InputStreamReader streamReader = new InputStreamReader(body);

        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
            StringBuilder responseBody = new StringBuilder();

            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }

            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
    }
    
    @RequestMapping(value = "/olmapi/treeList", method = RequestMethod.GET)
	@ResponseBody
	public void getItemTerms(HttpServletRequest req, HttpServletResponse res) throws Exception {
		Map setMap = new HashMap();
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");
		try {
	        String languageID = StringUtil.checkNull(req.getParameter("languageID"),"");
	        String SelectMenuId = StringUtil.checkNull(req.getParameter("SelectMenuId"),"");
	        setMap.put("sessionCurrLangType",languageID);
	        setMap.put("SelectMenuId", SelectMenuId);
	        
	        HttpSession session = req.getSession(false); // 기존 세션이 없으면 새로 생성하지 않음
	        
            if ( session.getAttribute("sessionUserId") != null) {
            	List list = commonService.selectList("menu_SQL.menuTreeListNoFilter_treeList", setMap);
    	        JSONArray result = convertListToJson(list);
    	        res.getWriter().print(result);
            } else {
            	res.getWriter().print("세션이 만료되었습니다");
            	res.setStatus(res.SC_UNAUTHORIZED);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
	}
    
    @RequestMapping(value = "/olmapi/plainText", method = RequestMethod.GET)
	@ResponseBody
	public void getPlainText(HttpServletRequest req, HttpServletResponse res) throws Exception {
		Map setMap = new HashMap();
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");
		try {
	        String languageID = StringUtil.checkNull(req.getParameter("languageID"),"");
	        String attrTypeCodes[] = StringUtil.checkNull(req.getParameter("attrTypeCode"),"").split(",");
	        String attrTypeCode = "";
	        String itemClassCode = StringUtil.checkNull(req.getParameter("itemClassCode"),"");
	        String searchValue = StringUtil.checkNull(req.getParameter("searchValue"),"");
	        
	        HttpSession session = req.getSession(false); // 기존 세션이 없으면 새로 생성하지 않음
            
            Map loginInfo = (Map)session.getAttribute("loginInfo");
            
            if ( session.getAttribute("sessionUserId") != null || !loginInfo.isEmpty()) {
		        setMap.put("languageID",languageID);
		        setMap.put("searchValue",searchValue);
				if (!attrTypeCodes.equals("")) {
					for (int i = 0; i < attrTypeCodes.length; i++) {
						if(i==0) {
							attrTypeCode = "'"+attrTypeCodes[i]+"'";
						}else {
							attrTypeCode += ",'"+ attrTypeCodes[i]+"'";
						}
					}
					setMap.put("attrTypeCode", attrTypeCode);
				}
		        setMap.put("itemClassCode",itemClassCode);
		        
		        List list = commonService.selectList("item_SQL.getItemsPlainText", setMap);
		        for (int i=0; list.size()> i; i++) {
		        	Map map = (Map) list.get(i);
		        	map.put("PlainText", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText"))));
		        	list.set(i, map);
		        }
		        JSONArray result = convertListToJson(list);
				res.getWriter().print(result);
            } else {
            	res.getWriter().print("세션이 만료되었습니다");
            	res.setStatus(res.SC_UNAUTHORIZED);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
	}
    
	@RequestMapping(value = "/olmapi/activeAccount", method = RequestMethod.GET)
	@ResponseBody
	public void getActvieAccount(HttpServletRequest req,  HttpServletResponse res, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String loginID = StringUtil.checkNull(req.getParameter("loginID"),"");
	    	String languageID = StringUtil.checkNull(req.getParameter("languageID"),"");
	    	setMap.put("LOGIN_ID", loginID);
	    	
	    	String result = commonService.selectString("login_SQL.login_active_select", setMap);
	    	
	    	if(result.equals("Y")) {
	    		setMap.put("active", "1");
	    		setMap.put("LANGUAGE", languageID);
	    		Map userInfo = commonService.select("login_SQL.login_select", setMap);
	    		
	            HttpSession session = req.getSession();
	            int timeout = session.getMaxInactiveInterval(); // 이미 설정된 값 가져오기
	            session.setMaxInactiveInterval(timeout); // 세션 갱신

	            session.setAttribute("sessionUserId", userInfo.get("sessionUserId"));
	            
	    		setMap.put("sessionUserId", userInfo.get("sessionUserId"));
	    		setMap.put("sessionTeamId", userInfo.get("sessionTeamId"));
	    		setMap.put("sessionClientId", userInfo.get("sessionClientId"));
	    		setMap.put("ActionType", "MOBILE");
	    		commonService.insert("gloval_SQL.insertVisitLog", setMap);
	    	}
	    	
			jsonObject.put("result", result);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
}
	
