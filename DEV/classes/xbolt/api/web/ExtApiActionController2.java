package xbolt.api.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import xbolt.cmm.framework.util.StringUtil;

@Controller
public class ExtApiActionController2 {	
	@RequestMapping(value = "/olmapi/naverTrans", method = RequestMethod.POST)
	@ResponseBody
	public void getTransData(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		response.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    
//		String clientId = "8edmclgm3y";//애플리케이션 클라이언트 아이디값";
//		String clientSecret = "RedaCa7Er2wkgU0g4JAJisyeJJ7HZI3wXuWPLU8l"; //애플리케이션 클라이언트 시크릿값";
	    String clientId = apiGlobalVal.PAPAGO_TRANS_CLIENT_ID;//애플리케이션 클라이언트 아이디값";
		String clientSecret = apiGlobalVal.PAPAGO_TRANS_CLIENT_SECRET; //애플리케이션 클라이언트 시크릿값";
		
		JSONObject result = new JSONObject();
        
	    OutputStream outputStream = null;
	    BufferedReader bufferedReader = null;
	    BufferedWriter bufferedWriter = null;
	    String resultString = "";
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

            URL url = new URL("https://papago.apigw.ntruss.com/nmt/v1/translation");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
            con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            
            JSONObject sendData = new JSONObject();
            sendData.put("source", jsonMap.get("source"));
            sendData.put("target", jsonMap.get("target"));
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
                System.out.println("inputLine == "+inputLine);
                res.append(inputLine);
            }

            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject)jsonParser.parse(res.toString());
            JSONObject message = (JSONObject)jsonObject.get("message");
        	result = (JSONObject)message.get("result");
            resultString = (String) result.get("translatedText");
            
            response.getWriter().print(resultString);
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
	
	@RequestMapping(value = "/olmapi/langDect", method = RequestMethod.POST)
	@ResponseBody
	public void langDect(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		response.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    
//		String clientId = "8edmclgm3y";//애플리케이션 클라이언트 아이디값";
//		String clientSecret = "RedaCa7Er2wkgU0g4JAJisyeJJ7HZI3wXuWPLU8l"; //애플리케이션 클라이언트 시크릿값";
	    String clientId = apiGlobalVal.PAPAGO_DECT_CLIENT_ID;//애플리케이션 클라이언트 아이디값";
		String clientSecret = apiGlobalVal.PAPAGO_DECT_CLIENT_SECRET; //애플리케이션 클라이언트 시크릿값";
		JSONObject result = new JSONObject();
        
	    OutputStream outputStream = null;
	    BufferedReader bufferedReader = null;
	    BufferedWriter bufferedWriter = null;
	    String resultString = "";
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

            URL url = new URL("https://papago.apigw.ntruss.com/langs/v1/dect");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
            con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            
            JSONObject sendData = new JSONObject();
            sendData.put("query", jsonMap.get("query"));
            
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
                System.out.println("inputLine == "+inputLine);
                res.append(inputLine);
            }

            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject)jsonParser.parse(res.toString());
            resultString = (String) jsonObject.get("langCode");
            
            response.getWriter().print(resultString);
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
    
    @RequestMapping(value = "/olmapi/test", method = RequestMethod.GET)
	@ResponseBody
	public void getItemTerms(HttpServletRequest req, HttpServletResponse res) throws Exception {
		Map setMap = new HashMap();
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		try {	        
			res.getWriter().print("test api 호출 성공");
        } catch (Exception e) {
            System.out.println(e);
        }
	}
}
	
