package xbolt.cmm.framework.util.drm;

import com.fasoo.adk.packager.WorkPackager;
import com.markany.nt.WDSCryptAll;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.framework.val.GlobalVal;

import com.org.json.JSONException;

import SCSL.SLDsFile;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
//import com.org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@SuppressWarnings("unused")
public class DRM_MIP_KEFICO {

	
	/* DRM 업로드 --> 업로드시 복호화 */ 
	public static String upload(HashMap drmInfoMap)  {
		String returnValue = "";
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"),"");
		String filePath = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),""); //암호 해제 파일 위치 // //OLMFILE/document/fltp001
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"),"");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"),"");
		String systemId = StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID);
		String inputFilePath = "mipTest/";
		String outputFilePath = "mipTest/de/";
		String mip_FilePath = "D://OLMFILE//mipTest//";
		String justificationMessage="TEST";
		returnValue = filePath+Filename;
		try {
		// 원본 파일을 복호화 작업용 임시 폴더로 복사  -> 복호화 작업을 별도 폴더에서 실행   원본 -> 임시 폴더 

		FileUtil.copyFile(filePath + Filename, mip_FilePath + Filename);

		//복호화 api 호출하기 
		String url = StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/Label/decrypt";
	    String requestStr =  "{\"SystemId\":\"" + StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)
	     					  +"\",\"inputFilePath\":\"" + inputFilePath + Filename
	     					  +"\",\"outputFilePath\":\"" +outputFilePath+ Filename //작업 후 파일경로 
	     					  +"\",\"justificationMessage\":\"" +justificationMessage+"\"}";
	    

	    System.out.println("=== AIP Upload IsFileDecrypted reqeust == "+requestStr);
		// 암호화 여부 확인
	    JSONObject res = sendPostRequest(url,requestStr);
	    Boolean success = (Boolean) res.get("success");
	    String appliedLabelName = (String)res.get("appledLabelName");
	    String message = (String) res.get("message");
	    
	    
		    if (success) {// 복호화 성공시 
		    	   System.out.println("복호화 성공"+res);
		    	   returnValue = "success";
		            // 복호화 파일을 다시 원래 경로에 덮어쓰기 (임시폴더 -> 원본)
		            FileUtil.copyFiles(mip_FilePath+"out//"+Filename, filePath+Filename);	
	        } else { // 복호화 실패시 
	        	if("NoPermissionsException".equals(appliedLabelName)) { // secret 보안 레이블 
	        	  returnValue = "secret";
	   	          System.out.println("❌  복호화 실패");
	   	          throw new RuntimeException("❌  업로드 실패(secret 레이블)"+message);
	        	}else { // 복호화 실패
		        	 System.out.println("❌ 복호화 실패"+message);
		 	        
		        }
	         
	         
	        }
	    // 복호화 작업이 끝난 임시 파일 삭제 
		FileUtil.deleteFile(mip_FilePath+Filename);
		//FileUtil.deleteFile(mip_FilePath+"out//"+Filename);
	
	   }catch (Exception e) {
			System.out.println(e.getStackTrace());
		}
	  	return returnValue;
	}
	
	/* DRM 다운로드  --> 다운로드시 암호화*/
	public static String download(HashMap drmInfoMap) throws Exception {
		String returnValue = "";		
		
		System.out.println("start");		

		String filePath = StringUtil.checkNull(drmInfoMap.get("downFile"),""); //다운로드 파일 위치 //OLMFILE/document/fltp001
		//String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),""); //
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"),"");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"),"");
		String systemId = StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID);
		String inputFilePath = "mipTest/";
		String outputFilePath = "mipTest/en/";
		String mip_FilePath = "D://OLMFILE//mipTest//";
		String justificationMessage="TEST";
		String corp = "KGP";
		String type = StringUtil.checkNull(drmInfoMap.get("type"),"");
		
		try {
		// 원본 파일을 복호화 작업용 임시 폴더로 복사  -> 복호화 작업을 별도 폴더에서 실행   원본 -> 임시 폴더 


		FileUtil.copyFile(filePath , mip_FilePath + Filename); // 원본 파일 복사 

		//복호화 api 호출하기 
		String url = StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/Label/decrypt";
	    String requestStr =  "{\"SystemId\":\"" + StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)
	     					  +"\",\"inputFilePath\":\"" + inputFilePath + Filename
	     					  +"\",\"outputFilePath\":\"" +outputFilePath+ Filename //작업 후 파일경로 
	     					  +"\",\"justificationMessage\":\"" +justificationMessage
	     					  +"\",\"corp\":\"" +corp+"\"}";  // 추가된 파라미터
	    
	
	    System.out.println("=== AIP Upload IsFileEncrypted reqeust == "+requestStr);

	    JSONObject res = sendPostRequest(url,requestStr); //암호화 api 호출 
	    Boolean success = (boolean)res.get("success"); 
	    String appliedLabelName = (String) res.get("appledLabelName");
	    String message = (String) res.get("message");
	    
	    if(!type.equals("CHK")) {//drmCheck.do 이미 호출 한뒤 
	    	if (success) {// 암호화 성공시 
		        System.out.println("암호화 성공");
	            returnValue = "";
	             // 복호화 파일을 다시 원래 경로에 덮어쓰기 (임시폴더 -> 원본)
	            FileUtil.copyFiles(mip_FilePath+"en//"+Filename, filePath);
		    	
	        } else {// 암호화 실패 
	        	
	        	if("NoPermissionsException".equals(appliedLabelName)) { //secret 보안 레이블 
	        		returnValue = "secret";
	        		System.out.println("암호화 실패(secret 레이블) :"+ message);
	        		
	        	}else {
	            	// 그 외 암호화 실패 
		        	 System.out.println("❌ 암호화 실패"+message);
	        	}
	    
	        
	        }
	    }
	    
	    // 암호화 끝난 임시 파일 삭제 
		FileUtil.deleteFile(mip_FilePath+Filename);
		//FileUtil.deleteFile(mip_FilePath+"out//"+Filename);
	
	   }catch (Exception e) {
			System.out.println(e.getStackTrace());
		}
	  	return returnValue;
	}

	public static String report(HashMap drmInfoMap) throws ExceptionUtil {
		String returnValue = "";		

		int fileType = 0;
		try {				
			String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"),"");
			if(filePath.equals("")){
				filePath = FileUtil.FILE_EXPORT_DIR;
			}
						
			String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName
			String userID = StringUtil.checkNull(drmInfoMap.get("userID"),"");
			
			SLDsFile sFile = new SLDsFile();
			sFile.SettingPathForProperty(DrmGlobalVal.DRM_SOFTCAMP_MODULE_PATH); 
			
			sFile.SLDsInitDAC();                                                 
			sFile.SLDsAddUserDAC("SECURITYDOMAIN", "111001100", 0, 0, 0); 
			
			int ret;
			ret = sFile.SLDsEncFileDACV2(DrmGlobalVal.DRM_SOFTCAMP_KEY,  "System", 
				  filePath.replace("//","\\").replace("/", "\\") + filename_org, 
				  StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH).replace("//","\\").replace("/", "\\") + "\\" + filename_org, 0);                             
		
			System.out.println("SLDsEncFileDAC :" + ret);
			returnValue = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + "//" + filename_org;
			
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return returnValue;
	}
	
	
    public static JSONObject sendPostRequest(String urlStr, String jsonData) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; utf-8");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonData.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int status = conn.getResponseCode();
        if (status == 200) {
            try (BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = in.readLine()) != null) {
                    response.append(line.trim());
                }
                //JSON 파싱
                JSONParser parser = new JSONParser();
                JSONObject resJson = (JSONObject) parser.parse(response.toString());
                System.out.println("response:"+resJson);
                return resJson;// 성공여부만 반환
            }
        } else {
            System.err.println("❌ HTTP 오류 코드: " + status);
            return null;
        }
    }
	  
    /*
	   public static void parseJsonResponse(String json) {
	        // 간단한 문자열 파싱 (정규식 사용 안 함)
	        boolean success = json.contains("\"success\":true");
	        String outputFilePath = extractValue(json, "outputFilePath");
	        String appliedLabelName = extractValue(json, "appliedLabelName");
	        String message = extractValue(json, "message");

	        // 결과 출력
	        if (success) {
	            System.out.println("✅ 레이블 적용 성공");
	            System.out.println("📁 출력 경로: " + outputFilePath);
	            System.out.println("🏷️ 적용된 레이블: " + appliedLabelName);
	            System.out.println("📩 메시지: " + message);
	        } else {
	            System.out.println("❌ 실패");
	            System.out.println("📩 메시지: " + message);
	        }
	    }

	    public static String extractValue(String json, String key) {
	        // "key":"value" 구조에서 value 추출
	        String searchKey = "\"" + key + "\":";
	        int index = json.indexOf(searchKey);
	        if (index == -1) return "";

	        int start = json.indexOf("\"", index + searchKey.length()) + 1;
	        int end = json.indexOf("\"", start);
	        if (start < 0 || end < 0) return "";
	        return json.substring(start, end);
	    }
	    */
}