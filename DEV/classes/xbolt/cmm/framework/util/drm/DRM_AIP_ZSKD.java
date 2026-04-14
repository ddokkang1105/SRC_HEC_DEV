package xbolt.cmm.framework.util.drm;

import com.markany.nt.WDSCryptAll;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.framework.val.GlobalVal;

import com.org.json.JSONException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

@SuppressWarnings("unused")
public class DRM_AIP_ZSKD {
	static String operationUserID = "aipgwforlegacy@skdiscovery.onmicrosoft.com"; // 요청 clientID
	
	/* 복호화 작업 */
	public static String upload(HashMap drmInfoMap) {		
		String returnValue = "";
		try {
			// 1. 복호화 하기 위해 파일 aip server로 upload
			// 2. 암호화 여부 확인
			// 3. 암호화된파일이면 복호화 진행하여 download
			
			// String apiUrl = "http://aipgwdev.skdiscovery.com/api/file/8a629561-5f41-45ed-92c9-d5bddb2765bd";
		    // String filePath = "path/to/your/file.txt";
								
			String pid = StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID);
			String filePath = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),""); // 암호화 대상 문서 FullPath // C://OLMFILE//document/FLT016//
			String fileName = StringUtil.checkNull(drmInfoMap.get("Filename")); // sysfilename
			returnValue = filePath + fileName;
			System.out.println("11111 pload returnValue :"+returnValue);
			String fID = sendMultipartFormData(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+pid, filePath + "/" + fileName); // aip 로 file upload
			System.out.println("upload 함수 file aip upload fid :"+fID);
			// 암호화 여부 확인
			if(!fID.equals("")) {
				if(isFileEncrypted(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPEncryption/IsFileEncrypted/"+fID+"/"+pid)) { // 암호파일이면
					// 복호화				
					// POST 요청
					//String postData = "operationUserID=I21575%40partner.skdiscovery.com&FID=ac0384b7-fd32-496c-8874-05860f00e086&PID=8a629561-5f41-45ed-92c9-d5bddb2765bd";
					// String postData = "UserID="+drmInfoMap.get("sessionEmail")+"&FID="+fID+"&PID="+pid;
					// aipgwforlegacy@skdiscovery.onmicrosoft.com
					String postData = "UserID="+operationUserID+"&FID="+fID+"&PID="+pid;
		            String decryptionResult = sendHttpRequest("POST", StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPDecryption", postData, null); // 복호화 method POST
		            
		            JSONParser parser = new JSONParser();
					Object obj = parser.parse(decryptionResult);
					
					JSONObject decryptionResultJson = new JSONObject();
					decryptionResultJson = (JSONObject) obj;
					
					String status = StringUtil.checkNull(decryptionResultJson.get("Status")); // Success : 4, Fail : 5
					fID = StringUtil.checkNull(decryptionResultJson.get("FID"));
					String errorMsg = StringUtil.checkNull(decryptionResultJson.get("ErrorMsg"));
					String outputFilePath = StringUtil.checkNull(decryptionResultJson.get("OutputFilePath"));
					
				    System.out.println("===복호화된 파일 decryption result outputFilePath: " + outputFilePath);
				    if(status.equals("4")) { // 복호솨 성공하면 경로에 파일 다운로드구현
				    	 URL url = new URL(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/Api/file/"+fID+"/"+pid);
				         Path destination = Paths.get(filePath + "/" + fileName);
				         // 파일 복사
				         Files.copy(url.openStream(), destination, StandardCopyOption.REPLACE_EXISTING);
				         System.out.println("복호화한 파일 다운로드 수행완료 ! 다운로드 받아진 경로 :"+ filePath + "/"+fileName);
				         
				         /// 암호화한 파일 다운로드							
				         /*
				         System.out.println("업로드 내부 암호화 파일 다운로드 "); 
				         HttpURLConnection conn = (HttpURLConnection) url.openConnection(); 
				         int responseCode = conn.getResponseCode();
							 
						if(responseCode == HttpURLConnection.HTTP_OK){ 
							InputStream is = null;
						    FileOutputStream os = null;
							is = conn.getInputStream(); os = new FileOutputStream(new File(filePath, fileName)); // filePath : C://OLMFILE//document/FLT016//
							 
							final int BUFFER_SIZE = 4096; int bytesRead; byte[] buffer = new byte[BUFFER_SIZE];
							  
							while((bytesRead = is.read(buffer)) != -1){ 
								os.write(buffer, 0, bytesRead); 
							}
							
							os.close(); is.close();
							
						} else {
							System.out.println("fail to connect server.  upload 내부 암호화된 파일 다운로드 오류"); 
						}
						*/
				    }
				}
			}

		} catch (Exception e) {
			System.out.println(e.getStackTrace());
		}
	  	return returnValue;
	}
	
	private static String sendHttpRequest(String method, String apiUrl, String postData, Map<String, String> queryParams) throws IOException {
        StringBuilder urlString = new StringBuilder(apiUrl);
        String outputParam = "";
        // GET 요청이면서 쿼리 파라미터가 있는 경우 URL에 추가
        if ("GET".equals(method) && queryParams != null && !queryParams.isEmpty()) {
            urlString.append("?");
            for (Map.Entry<String, String> entry : queryParams.entrySet()) {
                urlString.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
                urlString.append("=");
                urlString.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
                urlString.append("&");
            }
            urlString.deleteCharAt(urlString.length() - 1); // 맨 끝의 & 제거
        }

        URL url = new URL(urlString.toString());
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod(method);
        
        System.out.println("method :"+method+", apiURl :"+apiUrl+", postData :"+postData);

        if ("POST".equals(method)) {
            // POST 요청일 경우
            connection.setDoOutput(true);
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            try (OutputStream outputStream = connection.getOutputStream()) { // 데이터를 서버로 전송하는 작업을 수행
                outputStream.write(postData.getBytes("UTF-8"));  // 문자열을 UTF-8로 인코딩하여 서버에 전송
            } 
        }

        // 응답 확인
        int responseCode = connection.getResponseCode();
        System.out.println("HTTP 응답 코드: " + responseCode);
        
        if (responseCode == 400) {
		    System.out.println("400:: 해당 명령을 실행할 수 없음 ");
		} else if (responseCode == 401) {
		    System.out.println("401:: X-Auth-Token Header가 잘못됨");
		} else if (responseCode == 500) {
		    System.out.println("500:: 서버 에러, 문의 필요");
		} else if (responseCode == connection.HTTP_OK){
        // 응답 내용 읽기
	        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
	            String line;
	            StringBuilder response = new StringBuilder();
	            while ((line = reader.readLine()) != null) {
	                response.append(line);
	            }
	            outputParam = response.toString();
	            System.out.println("서버 응답: " + response.toString() +" :::: 호출 api url  : "+apiUrl);
	        }
		}
        // 연결 종료
        connection.disconnect();
        
        return outputParam;
    }

	private static String sendMultipartFormData(String apiUrl, String filePath) throws IOException, ParseException {
		String fID = "";
		try { 
			System.out.println("sendMultipartFormData apiUrl :"+apiUrl+", filePath :"+filePath);
			 
			 File file = new File(filePath);
	         String boundary = "---------------------------8d8190a4594aa82";
	
	         URL url = new URL(apiUrl);
	         HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	         connection.setRequestMethod("POST");
	         connection.setDoOutput(true);
	         connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
	        
	         try (OutputStream outputStream = connection.getOutputStream();
	              PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream, "UTF-8"), true)) {
	
	             // 파일 파트 전송
	        	 writer.println("--" + boundary);
	        	 writer.println("Content-Disposition: form-data; name="+StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)+"; filename=\"" + file.getName() + "\"");
	        	 writer.println("Content-Type: application/vnd.openxmlformats-officedocument.wordprocessingml.document");
	        	 writer.println();
	        	 try (FileInputStream fileInputStream = new FileInputStream(file)) {
	        		 byte[] buffer = new byte[4096];
	        		 int bytesRead;
	        		 while ((bytesRead = fileInputStream.read(buffer)) != -1) {
	                    outputStream.write(buffer, 0, bytesRead);
	        		 }
	        		 outputStream.flush();
	        	 }
	        	 writer.println();
	
	        	 writer.println("--" + boundary + "--");
	        }
	
	        // 응답 확인
	        int responseCode = connection.getResponseCode();
	        System.out.println("HTTP 응답 코드: " + responseCode);
	        
	        if (responseCode == 400) {
			    System.out.println("400:: 해당 명령을 실행할 수 없음 ");
			} else if (responseCode == 401) {
			    System.out.println("401:: X-Auth-Token Header가 잘못됨");
			} else if (responseCode == 500) {
			    System.out.println("500:: 서버 에러, 문의 필요");
			} else if (responseCode == connection.HTTP_OK){
				// 응답 내용 확인
		        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
		            String line;
		            StringBuilder sb = new StringBuilder();
		            while ((line = reader.readLine()) != null) {
		                sb.append(line);
		            }
		            System.out.println("서버 응답: " + sb.toString());
		            
		            line = sb.toString();
				    
					JSONParser parser = new JSONParser();
					Object obj = parser.parse(line);
					
					JSONObject outPutParam = new JSONObject();
					outPutParam = (JSONObject) obj;
					
					
					String result = StringUtil.checkNull(outPutParam.get("result")); // Success : 1, Fail : 2
					fID = StringUtil.checkNull(outPutParam.get("fid"));
					String ErrorMsg = StringUtil.checkNull(outPutParam.get("errorMsg"));
					
				    System.out.println("=== upload result : " + result);
				    System.out.println("=== upload FID : " + fID);
				    System.out.println("=== upload result :" + ErrorMsg);
		        }
			}
	        connection.disconnect();
	        
		} catch (IOException | ParseException e) {
	        e.printStackTrace();
	    }
		System.out.println("Line  284 sendMultipartFormData fID :"+fID);
		return  fID;
    }
	
	// 암호화하기 
	public static String download(HashMap drmInfoMap) throws Exception {
		// 1. aip server 에 암호화 대상 파일 upload
		// 2. 암호화,복호화 파일인지 확인
		// 3. 암호화 
		
		String pid = StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID);
		String filePath = StringUtil.checkNull(drmInfoMap.get("downFile"),""); // 암호화 대상 문서 FullPath //  ISNULL(tft.FilePath,tif.FilePath) + tif.FileName as downFile
		String drmFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),"");  // DrmGlobalVal.DRM_DECODING_FILEPATH + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//"
		String fileName = StringUtil.checkNull(drmInfoMap.get("Filename"));
		String labelID = "dba323f4-ad47-4a6a-a0af-5810d929a288";
		
		String FILE_AIP_EXTENSION[] = StringUtil.checkNull(DrmGlobalVal.FILE_AIP_EXTENSION,"").split(","); 
		String extension = fileName.substring(fileName.lastIndexOf(".") + 1);

		// 확장자가 허용 목록에 있는지 확인
		boolean isAllowed = false;
		for (String allowedExtension : FILE_AIP_EXTENSION) {
		    if (extension.equalsIgnoreCase(allowedExtension.trim())) {
		        isAllowed = true;
		        break;
		    }
		}
		
		String returnValue = "";
		// 허용된 확장자인지 확인
		if (!isAllowed) {
			System.out.println(" not allowed extension! ");
			return returnValue;
		}
		
		String fID = sendMultipartFormData(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+pid, filePath); // aip 로 file upload
		
		// 암호화 여부 확인
		if(!fID.equals("")) {
			if(!isFileEncrypted(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPEncryption/IsFileEncrypted/"+fID+"/"+pid)) { // 복호화된 파일이면
				returnValue =  drmFileDir + fileName;
				System.out.println("복호화된 파일이니까.. 암호화 하기 ! :"+returnValue);
				// POST 요청
				//String postData = "OperationUserID=I21575%40partner.skdiscovery.com&FID=ac0384b7-fd32-496c-8874-05860f00e086&PID=8a629561-5f41-45ed-92c9-d5bddb2765bd";
				String postData = "OperationUserID="+operationUserID+"&LabelID="+labelID+"&FID="+fID+"&PID="+pid;
	            String encryptionResult = sendHttpRequest("POST", StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPEncryption/Label", postData, null); // 암호화 method POST
	            
	            JSONParser parser = new JSONParser();
				Object obj = parser.parse(encryptionResult);
				
				JSONObject encryptionResultJson = new JSONObject();
				encryptionResultJson = (JSONObject) obj;
				
				String status = StringUtil.checkNull(encryptionResultJson.get("Status")); // Success : 0, Fail : 1
				fID = StringUtil.checkNull(encryptionResultJson.get("FID"));
				String errorMsg = StringUtil.checkNull(encryptionResultJson.get("ErrorMsg"));
				String outputFilePath = StringUtil.checkNull(encryptionResultJson.get("OutputFilePath"));
							
			    System.out.println("=== encryption result status :"+status+", outputFilePath: " + outputFilePath);
			    if(status.equals("0")) {
			    	 
			    	 Path directory = Paths.get(drmFileDir);
			         if (!Files.exists(directory)) {
			            Files.createDirectories(directory);
			         }
			        
			    	 URL url = new URL(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+fID+"/"+pid);
			         Path destination = Paths.get(drmFileDir + "/" + fileName);
			         
			         // 파일 복사
			         Files.copy(url.openStream(), destination, StandardCopyOption.REPLACE_EXISTING);
			         System.out.println("downLoad 내부 파일 암호화 수행후 해당파일 다운로드 수행 완료  :: 다운로드받아진 경로 : "+drmFileDir + fileName);
			    }
			    
			} else {
				returnValue =  "";
				System.out.println("downlaod 암호화가 되어 있는 파일이므로 returnpath 비우기  :"+returnValue);
			}
		}
		System.out.println("downlaod aip return path :"+returnValue);
		return returnValue;
	}
		
	private static boolean isFileEncrypted(String apiUrl) throws Exception { // 암호화 여부 
		Boolean retrnValue = false;
		System.out.println("암호화 복호화 확인 isFileEncrypted apiUrl :"+apiUrl);
		try {
			URL url = new URL(apiUrl);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setConnectTimeout(5000); // 연결 타임아웃 5초
            connection.setReadTimeout(5000);    // 읽기 타임아웃 5초

            // 요청 헤더 설정 (옵션)
            connection.setRequestProperty("Connection", "Keep-Alive");
			
			int responseCode = connection.getResponseCode();
			
			if (responseCode == 400) {
			    System.out.println("400:: 해당 명령을 실행할 수 없음 ");
			} else if (responseCode == 401) {
			    System.out.println("401:: X-Auth-Token Header가 잘못됨");
			} else if (responseCode == 500) {
			    System.out.println("500:: 서버 에러, 문의 필요");
			} else if (responseCode == connection.HTTP_OK){
				// 응답 내용 확인
		        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
		            String line;
		            StringBuilder sb = new StringBuilder();
		            while ((line = reader.readLine()) != null) {
		                sb.append(line);
		            }
		            System.out.println("서버 응답[isFileEncrypted]: " + sb.toString());
		            
		            line = sb.toString();
				    
					JSONParser parser = new JSONParser();
					Object obj = parser.parse(line);
					
					JSONObject outPutParam = new JSONObject();
					outPutParam = (JSONObject) obj;
					
					retrnValue = Boolean.parseBoolean(StringUtil.checkNull(outPutParam.get("Result")));
					String ErrorMsg = StringUtil.checkNull(outPutParam.get("ErrorMsg"));
					
				    System.out.println("=== isFileEncrypted retrnValue : " + retrnValue);
				    System.out.println("=== isFileEncrypted ErrorMsg :" + ErrorMsg);
		        }
			}

            // 연결 종료
            connection.disconnect();
		} catch(IOException e) {
			System.out.println("IOException "+e.getCause());
			e.printStackTrace();
		} catch(Exception e) {
			System.out.println("Exception "+e.getCause());
			e.printStackTrace();
		}
		return retrnValue;
 	}
	
	public static String report(HashMap drmInfoMap) throws Exception {
		// 1. aip server에 파일 업로드 
		// 2. aip 암호화 후 download
		String pid = StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID);
		String labelID = "dba323f4-ad47-4a6a-a0af-5810d929a288";
		
		String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"),"");
		if(filePath.equals("")){
			filePath = FileUtil.FILE_EXPORT_DIR; // C:/OLM3.5/webapps//ROOT//doc//export//
		}
		String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName
		// aip server 에 파일 upload
		String fID = sendMultipartFormData(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+pid, filePath + filename_org); // aip 로 file upload
		
		// 암호화
		if(!fID.equals("")) {
			// POST 요청
			//String postData = "UserID=I21575%40partner.skdiscovery.com&FID=ac0384b7-fd32-496c-8874-05860f00e086&PID=8a629561-5f41-45ed-92c9-d5bddb2765bd";
			String postData = "OperationUserID="+operationUserID+"&LabelID:"+labelID+"&FID="+fID+"&PID="+pid;
            String encryptionResult = sendHttpRequest("POST", StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPEncryption/Label", postData, null); // 암호화 method POST
            
            JSONParser parser = new JSONParser();
			Object obj = parser.parse(encryptionResult);
			
			JSONObject encryptionResultJson = new JSONObject();
			encryptionResultJson = (JSONObject) obj;
			
			String status = StringUtil.checkNull(encryptionResultJson.get("Status")); // Success : 0, Fail : 1
			fID = StringUtil.checkNull(encryptionResultJson.get("fID"));
			String errorMsg = StringUtil.checkNull(encryptionResultJson.get("errorMsg"));
			String outputFilePath = StringUtil.checkNull(encryptionResultJson.get("outputFilePath"));
						
		    System.out.println("=== encryption result status :"+status+", outputFilePath: " + outputFilePath);
		    if(status.equals("0")) {
		   
		    	 URL url = new URL(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+fID+"/"+pid);
		         Path destination = Paths.get(filePath + filename_org);
		         
		         // 파일 복사
		         Files.copy(url.openStream(), destination, StandardCopyOption.REPLACE_EXISTING);
		         System.out.println("report 암호화 파일 다운로드 완료 : 암호화된 파일 다운로드된 경로  ::"+ filePath + filename_org);
		    }
		}

		return filePath + filename_org;
	}
}