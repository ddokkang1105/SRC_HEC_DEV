package xbolt.custom.sk.skon;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import xbolt.cmm.framework.util.StringUtil;

@Controller
public class SKAuthActionController {    
    @RequestMapping(value = "/olmapi/skAuth", method = RequestMethod.GET)
	@ResponseBody
	public void skAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");

	    
		JSONObject result = new JSONObject();
        
	    OutputStream outputStream = null;
	    BufferedReader bufferedReader = null;
	    BufferedWriter bufferedWriter = null;
	    String resultString = "";
	    
//	    String sendUrl ="https://devgmp.sktelecom.com:9443/service.pe?"; // 개발
	    String sendUrl ="https://m.toktok.sk.com:9443/service.pe?"; // 운영
	    
		try {
			String primitive = StringUtil.checkNull(request.getParameter("primitive"),"");
			String companyCd = StringUtil.checkNull(request.getParameter("companyCd"),"");
	        String appId = StringUtil.checkNull(request.getParameter("appId"),"");
	        String appVer = StringUtil.checkNull(request.getParameter("appVer"));
	        String encPwd = StringUtil.checkNull(request.getParameter("encPwd"));
	        String osName = StringUtil.checkNull(request.getParameter("osName"));
	        String groupCd = StringUtil.checkNull(request.getParameter("groupCd"), "");
	        String lang = StringUtil.checkNull(request.getParameter("lang"), "");
	        String authKey = StringUtil.checkNull(request.getParameter("authKey"), "");
	        String osVersion = StringUtil.checkNull(request.getParameter("osVersion"), "");
	        String mdn = StringUtil.checkNull(request.getParameter("mdn"), "");
	        
	        sendUrl += "&primitive="+primitive;
	        sendUrl += "&companyCd="+companyCd;
	        sendUrl += "&appId="+appId;
	        sendUrl += "&appVer="+appVer;
	        sendUrl += "&encPwd="+encPwd;
	        sendUrl += "&osName="+osName;
	        sendUrl += "&groupCd="+groupCd;
	        sendUrl += "&lang="+lang;
	        sendUrl += "&authKey="+authKey;
	        sendUrl += "&osVersion="+osVersion;
	        sendUrl += "&mdn="+mdn;
	        
            URL url = new URL(sendUrl);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);

            System.out.println("==== sendUrl ===="+sendUrl);
            
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

            String xmlResponse = res.toString(); // 서버에서 받은 XML 응답 문자열
//            String xmlResponse = "<skmo><result>1000</result></skmo>"; // 서버에서 받은 XML 응답 문자열
            
            ByteArrayInputStream input = new ByteArrayInputStream(xmlResponse.getBytes("UTF-8"));

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(input);
            
            String resultTagValue = "";
            String resultMessageTagValue = "";
            String empIdTagValue = "";
            
         // <result> 추출
            NodeList resultList = doc.getElementsByTagName("result");
            if(resultList.getLength() > 0) {
            	resultTagValue = resultList.item(0).getTextContent();
                System.out.println("Result: " + resultTagValue);
            }

            // <resultMessage> 추출
            NodeList messageList = doc.getElementsByTagName("resultMessage");
            if(messageList.getLength() > 0) {
            	resultMessageTagValue = messageList.item(0).getTextContent();
                System.out.println("Result Message: " + resultMessageTagValue);
            }
            
            // <emdId> 추출
            NodeList empId = doc.getElementsByTagName("empId");
            if(empId.getLength() > 0) {
            	empIdTagValue = empId.item(0).getTextContent();
                System.out.println("empId: " + empIdTagValue);
            }
            
            result.put("result", resultTagValue);
            result.put("resultMessage", resultMessageTagValue);
            result.put("empId", empIdTagValue);
            
            response.getWriter().print(result);
            System.out.println("result: " + result);
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
}
	
