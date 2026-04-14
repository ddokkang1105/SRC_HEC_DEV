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
import java.net.InetAddress;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
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
public class DRM_AIP_KDNVN {
	
	/* 복호화 작업 */
	public static String upload(HashMap drmInfoMap) {		
		String returnValue = "";
		try {
			// 1. GetSystemInfo API 호출 - LabelInfoID 추출
			// 2. 암호화 여부 확인 없이 복호화
			// 3. 복호화된 파일 파일 경로에 저장(덮어쓰기)
			
			String filePath = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),""); // 암호화 대상 문서 FullPath // D:\OLMFILE\document//
			String fileName = StringUtil.checkNull(drmInfoMap.get("Filename")); 
			String fileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName")); 
			String loginID = StringUtil.checkNull(drmInfoMap.get("userID")); 
			String userName = StringUtil.checkNull(drmInfoMap.get("userName")); 
			String teamName = StringUtil.checkNull(drmInfoMap.get("teamName")); 
			returnValue = filePath + fileName;
			System.out.println("11111 pload returnValue : "+returnValue);
//	        for (Object obj : drmInfoMap.entrySet()) {
//	            // Map.Entry로 캐스팅
//	            Map.Entry entry = (Map.Entry) obj;
//
//	            Object key = entry.getKey();   // Key 가져오기
//	            Object value = entry.getValue(); // Value 가져오기
//
//	            System.out.println("Key: " + key + ", Value: " + value);
//	        }
			System.out.println("=================================================");
			Map queryParams = new HashMap();
			queryParams.put("serviceKey", StringUtil.checkNull(DrmGlobalVal.AIP_SERVICEKEY));
			String returnGetSystemInfo = sendHttpRequest("GET",StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/services/app/Protect/GetSystemInfo", null, queryParams); 
            JSONParser parser = new JSONParser(); 
			Object obj = parser.parse(returnGetSystemInfo);
			
			JSONObject SystemInfoJson = new JSONObject();
			SystemInfoJson = (JSONObject) obj;
			
            JSONObject result = (JSONObject) SystemInfoJson.get("result");

            JSONArray systemLabelInfos = (JSONArray) result.get("systemLabelInfos");

            String labelInfoId = "";
            // 첫 번째 요소의 "labelInfoId" 추출
            if (systemLabelInfos != null && !systemLabelInfos.isEmpty()) {
                JSONObject firstLabelInfo = (JSONObject) systemLabelInfos.get(0);
                labelInfoId = (String) firstLabelInfo.get("labelInfoId");

                // 결과 출력
                System.out.println("첫 번째 LabelInfoId: " + labelInfoId);
            } else {
                System.out.println("LabelInfoId 값이 없습니다.");
                return "";
            }			
			
            String postData = "";
            String decryptionResult = ""; 
            if (!labelInfoId.equals("") && labelInfoId != null) {
            	// 복호화				
            	// POST 요청
            	
            	// Parameters
            	
            	// formFile - 파일
            	// UserLoginId
            	// UserName - 필수 X
            	// TemplateGUID - LabelID
            	// ComputerName - 필수 X
            	// UserPosition - 필수 X
            	// Department - 필수 X
            	// NotifyOwnerOnOpen = false
            	// FilePath - 필수 X
            	// ServiceKey = serviceKey
            	// FileName - 사용자가 올린 파일명
            	// PhysicalFileName - 물리적인 파일명

            	String ip = InetAddress.getLocalHost().getHostAddress();
            	// 파라미터 추가하기
            	Map paramMap = new HashMap();
            	paramMap.put("UserLoginId", loginID);
            	paramMap.put("UserName", userName);
            	paramMap.put("TemplateGUID", labelInfoId);
            	paramMap.put("ComputerName", ip);
            	paramMap.put("Department", teamName);
            	paramMap.put("NotifyOwnerOnOpen", "false");
            	paramMap.put("ServiceKey", DrmGlobalVal.AIP_SERVICEKEY);
            	paramMap.put("FileName", fileName);
            	paramMap.put("PhysicalFileName", fileRealName);
            	
//            	System.out.println("==============================================================");
//            	System.out.println("UserLoginId : " + loginID);
//            	System.out.println("UserName : " + userName);
//            	System.out.println("TemplateGUID : " + labelInfoId);
//            	System.out.println("ComputerName : " + ip);
//            	System.out.println("Department : " + teamName);
//            	System.out.println("NotifyOwnerOnOpen : " + "false");
//            	System.out.println("ServiceKey : " + DrmGlobalVal.AIP_SERVICEKEY);
//            	System.out.println("FileName : " + fileName);
//            	System.out.println("PhysicalFileName : " + fileRealName);
//            	System.out.println("==============================================================");
            	
//            	int time = 0;
//            	int timer = 5000;
//            	
//            	while (true) {
//            		if (time == 0) {
//						time = timer;
//					}
//            		
//            		System.out.println("작업 대기 시작...");
//            		Thread.sleep(timer); // 5초 대기
//            		System.out.printf("작업 대기 %d초 경과...", (time / 1000));
//					System.out.println();
//					
//            		if (time >= timer * 12) {
//            			System.out.println("대기 완료, 작업 실행!");
//            			break;
//					}
//            		
//            		time += timer;
//				}
            	
            	filePath = returnValue;
                sendMultipartFormData(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/services/app/Protect/StreamDecryption", returnValue, paramMap, filePath);
            	
			} else {
				return decryptionResult;
			}
			System.out.println("=================================================");
			

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
	
	public static void sendMultipartFormData(String apiUrl, String checkFile, Map paramMap, String downloadPath) {
	    String boundary = "---------------------------" + System.currentTimeMillis();
	    String charset = "UTF-8";

	    File file = new File(checkFile);
	    if (!file.exists()) {
	        System.err.println("파일이 존재하지 않습니다: " + checkFile);
	        return;
	    }

	    HttpURLConnection connection = null;
	    OutputStream outputStream = null;
	    PrintWriter writer = null;

	    try {
	        URL url = new URL(apiUrl);
	        connection = (HttpURLConnection) url.openConnection();

	        // HTTP 메서드 및 헤더 설정
	        connection.setRequestMethod("POST");
	        connection.setDoOutput(true);
	        connection.setDoInput(true);
	        connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
	        connection.setRequestProperty("accept", "application/json, application/octet-stream"); // JSON & 파일 응답 처리
	        connection.setRequestProperty("Authorization", "null");
	        connection.setRequestProperty("X-XSRF-TOKEN", "CfDJ8LSuPdygsLFFnWwjomRUKckTjGXNbqUOXaSCzcB8crdEW1gslxu-oF1g2wiG1GXkCEcaZoMzhpBT7dwg0vOYBQe0rdcnn23wac4Kry79ooJFHxLD99xXqX4iwefZR4TBODevksfi1m2RZ5GTzJy4Eg4");

	        // 데이터 전송 준비
	        outputStream = connection.getOutputStream();
	        writer = new PrintWriter(new OutputStreamWriter(outputStream, charset), true);

	        // 파일 파트 추가
	        addFilePart(writer, outputStream, boundary, "formFile", file);

	        // 텍스트 필드 추가
	        
	        addFormField(writer, boundary, "UserLoginId", StringUtil.checkNull(paramMap.get("UserLoginId")));
	        addFormField(writer, boundary, "UserName", StringUtil.checkNull(paramMap.get("UserName")));
	        addFormField(writer, boundary, "TemplateGUID", StringUtil.checkNull(paramMap.get("TemplateGUID")));
	        addFormField(writer, boundary, "ComputerName", StringUtil.checkNull(paramMap.get("ComputerName")));
	        addFormField(writer, boundary, "Department", StringUtil.checkNull(paramMap.get("Department")));
	        addFormField(writer, boundary, "NotifyOwnerOnOpen", StringUtil.checkNull(paramMap.get("NotifyOwnerOnOpen")));
	        addFormField(writer, boundary, "ServiceKey", StringUtil.checkNull(paramMap.get("ServiceKey")));
	        addFormField(writer, boundary, "FileName", StringUtil.checkNull(paramMap.get("FileName")));
	        addFormField(writer, boundary, "PhysicalFileName", StringUtil.checkNull(paramMap.get("PhysicalFileName")));

	        // 끝나는 boundary
	        writer.append("--").append(boundary).append("--").append("\r\n").flush();

	        // 응답 처리
	        int responseCode = connection.getResponseCode();
	        System.out.println("HTTP 응답 코드: " + responseCode);

	        if (responseCode == HttpURLConnection.HTTP_OK) {
	            String contentType = connection.getContentType();

	            if (contentType != null && contentType.startsWith("application/octet-stream")) {
	                // 파일 응답 처리
	                try (InputStream inputStream = connection.getInputStream();
	                     FileOutputStream fileOutputStream = new FileOutputStream(downloadPath)) {

	                    byte[] buffer = new byte[4096];
	                    int bytesRead;
	                    while ((bytesRead = inputStream.read(buffer)) != -1) {
	                        fileOutputStream.write(buffer, 0, bytesRead);
	                    }
	                    System.out.println("파일 다운로드 성공: " + downloadPath);
	                }
	            } else {
	                // JSON 응답 처리
	                try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), charset))) {
	                    StringBuilder sb = new StringBuilder();
	                    String line;
	                    while ((line = reader.readLine()) != null) {
	                        sb.append(line);
	                    }
	                    System.out.println("서버 응답: " + sb.toString());
	                }
	            }
	        } else {
	            System.err.println("서버 응답 에러: " + responseCode);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        // 연결 종료 및 자원 해제
	        if (writer != null) {
	            writer.close();
	        }
	        if (outputStream != null) {
	            try {
	                outputStream.close();
	            } catch (IOException e) {
	                System.err.println("OutputStream 닫기 오류: " + e.getMessage());
	            }
	        }
	        if (connection != null) {
	            connection.disconnect();
	        }
	    }
	}

	// 파일 파트 추가 메서드
	private static void addFilePart(PrintWriter writer, OutputStream outputStream, String boundary, String fieldName, File uploadFile) throws IOException {
	    writer.append("--").append(boundary).append("\r\n");
	    writer.append("Content-Disposition: form-data; name=\"").append(fieldName).append("\"; filename=\"").append(uploadFile.getName()).append("\"\r\n");
	    writer.append("Content-Type: application/pdf\r\n\r\n").flush();

	    try (FileInputStream inputStream = new FileInputStream(uploadFile)) {
	        byte[] buffer = new byte[4096];
	        int bytesRead;
	        while ((bytesRead = inputStream.read(buffer)) != -1) {
	            outputStream.write(buffer, 0, bytesRead);
	        }
	    }
	    outputStream.flush();
	    writer.append("\r\n").flush();
	}

	// 텍스트 필드 추가 메서드
	private static void addFormField(PrintWriter writer, String boundary, String fieldName, String fieldValue) {
	    writer.append("--").append(boundary).append("\r\n");
	    writer.append("Content-Disposition: form-data; name=\"").append(fieldName).append("\"\r\n\r\n");
	    writer.append(fieldValue).append("\r\n").flush();
	}

	
	// 암호화하기 
//	public static String download(HashMap drmInfoMap) throws Exception {
//		// 1. aip server 에 암호화 대상 파일 upload
//		// 2. 암호화,복호화 파일인지 확인
//		// 3. 암호화 
//		
//		String pid = StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID);
//		String filePath = StringUtil.checkNull(drmInfoMap.get("downFile"),""); // 암호화 대상 문서 FullPath //  ISNULL(tft.FilePath,tif.FilePath) + tif.FileName as downFile
//		String drmFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),"");  // DrmGlobalVal.DRM_DECODING_FILEPATH + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//"
//		String fileName = StringUtil.checkNull(drmInfoMap.get("Filename"));
//		//String labelID = "dba323f4-ad47-4a6a-a0af-5810d929a288";
//		
//		String FILE_AIP_EXTENSION[] = StringUtil.checkNull(DrmGlobalVal.FILE_AIP_EXTENSION,"").split(","); 
//		String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
//
//		// 확장자가 허용 목록에 있는지 확인
//		boolean isAllowed = false;
//		for (String allowedExtension : FILE_AIP_EXTENSION) {
//		    if (extension.equalsIgnoreCase(allowedExtension.trim())) {
//		        isAllowed = true;
//		        break;
//		    }
//		}
//		
//		String returnValue = "";
//		// 허용된 확장자인지 확인
//		if (!isAllowed) {
//			System.out.println(" not allowed extension! ");
//			return returnValue;
//		}
//		
//		String fID = sendMultipartFormData(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+pid, filePath); // aip 로 file upload
//		
//		// 암호화 여부 확인
//		if(!fID.equals("")) {
//			if(!isFileEncrypted(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPEncryption/IsFileEncrypted/"+fID+"/"+pid)) { // 복호화된 파일이면
//				returnValue =  drmFileDir + fileName;
//				System.out.println("복호화된 파일이니까.. 암호화 하기 ! :"+returnValue);
//				// POST 요청
//				//String postData = "OperationUserID=I21575%40partner.skdiscovery.com&FID=ac0384b7-fd32-496c-8874-05860f00e086&PID=8a629561-5f41-45ed-92c9-d5bddb2765bd";
//				
//				//String postData = "OperationUserID="+operationUserID+"&LabelID="+labelID+"&FID="+fID+"&PID="+pid;
//				////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//				String postData = "OperationUserID="+DrmGlobalVal.AIP_OPERATIONUSERID+"&LabelID="+DrmGlobalVal.AIP_LABELID+"&FID="+fID+"&PID="+pid;
//				////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//				
//	            String encryptionResult = sendHttpRequest("POST", StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPEncryption/Label", postData, null); // 암호화 method POST
//	            
//	            JSONParser parser = new JSONParser();
//				Object obj = parser.parse(encryptionResult);
//				
//				JSONObject encryptionResultJson = new JSONObject();
//				encryptionResultJson = (JSONObject) obj;
//				
//				String status = StringUtil.checkNull(encryptionResultJson.get("Status")); // Success : 0, Fail : 1
//				fID = StringUtil.checkNull(encryptionResultJson.get("FID"));
//				String errorMsg = StringUtil.checkNull(encryptionResultJson.get("ErrorMsg"));
//				String outputFilePath = StringUtil.checkNull(encryptionResultJson.get("OutputFilePath"));
//							
//			    System.out.println("=== encryption result status :"+status+", outputFilePath: " + outputFilePath);
//			    if(status.equals("0")) {
//			    	 
//			    	 Path directory = Paths.get(drmFileDir);
//			         if (!Files.exists(directory)) {
//			            Files.createDirectories(directory);
//			         }
//			        
//			    	 URL url = new URL(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+fID+"/"+pid);
//			         Path destination = Paths.get(drmFileDir + "/" + fileName);
//			         
//			         // 파일 복사
//			         Files.copy(url.openStream(), destination, StandardCopyOption.REPLACE_EXISTING);
//			         System.out.println("downLoad 내부 파일 암호화 수행후 해당파일 다운로드 수행 완료  :: 다운로드받아진 경로 : "+drmFileDir + fileName);
//			    }
//			    
//			} else {
//				returnValue =  "";
//				System.out.println("downlaod 암호화가 되어 있는 파일이므로 returnpath 비우기  :"+returnValue);
//			}
//		}
//		System.out.println("downlaod aip return path :"+returnValue);
//		return returnValue;
//	}
		
//	private static boolean isFileEncrypted(String apiUrl) throws Exception { // 암호화 여부 
//		Boolean retrnValue = false;
//		System.out.println("암호화 복호화 확인 isFileEncrypted apiUrl :"+apiUrl);
//		try {
//			URL url = new URL(apiUrl);
//			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
//			connection.setRequestMethod("GET");
//			connection.setConnectTimeout(5000); // 연결 타임아웃 5초
//            connection.setReadTimeout(5000);    // 읽기 타임아웃 5초
//
//            // 요청 헤더 설정 (옵션)
//            connection.setRequestProperty("Connection", "Keep-Alive");
//			
//			int responseCode = connection.getResponseCode();
//			
//			if (responseCode == 400) {
//			    System.out.println("400:: 해당 명령을 실행할 수 없음 ");
//			} else if (responseCode == 401) {
//			    System.out.println("401:: X-Auth-Token Header가 잘못됨");
//			} else if (responseCode == 500) {
//			    System.out.println("500:: 서버 에러, 문의 필요");
//			} else if (responseCode == connection.HTTP_OK){
//				// 응답 내용 확인
//		        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
//		            String line;
//		            StringBuilder sb = new StringBuilder();
//		            while ((line = reader.readLine()) != null) {
//		                sb.append(line);
//		            }
//		            System.out.println("서버 응답[isFileEncrypted]: " + sb.toString());
//		            
//		            line = sb.toString();
//				    
//					JSONParser parser = new JSONParser();
//					Object obj = parser.parse(line);
//					
//					JSONObject outPutParam = new JSONObject();
//					outPutParam = (JSONObject) obj;
//					
//					retrnValue = Boolean.parseBoolean(StringUtil.checkNull(outPutParam.get("Result")));
//					String ErrorMsg = StringUtil.checkNull(outPutParam.get("ErrorMsg"));
//					
//				    System.out.println("=== isFileEncrypted retrnValue : " + retrnValue);
//				    System.out.println("=== isFileEncrypted ErrorMsg :" + ErrorMsg);
//		        }
//			}
//
//            // 연결 종료
//            connection.disconnect();
//		} catch(IOException e) {
//			System.out.println("IOException "+e.getCause());
//			e.printStackTrace();
//		} catch(Exception e) {
//			System.out.println("Exception "+e.getCause());
//			e.printStackTrace();
//		}
//		return retrnValue;
// 	}
	
//	public static String report(HashMap drmInfoMap) throws Exception {
//		// 1. aip server에 파일 업로드 
//		// 2. aip 암호화 후 download
//		String pid = StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID);
//		//String labelID = "dba323f4-ad47-4a6a-a0af-5810d929a288";
//		
//		String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"),"");
//		if(filePath.equals("")){
//			filePath = FileUtil.FILE_EXPORT_DIR; // C:/OLM3.5/webapps//ROOT//doc//export//
//		}
//		String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName
//		// aip server 에 파일 upload
//		String fID = sendMultipartFormData(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+pid, filePath + filename_org); // aip 로 file upload
//		
//		// 암호화
//		if(!fID.equals("")) {
//			// POST 요청
//			//String postData = "UserID=I21575%40partner.skdiscovery.com&FID=ac0384b7-fd32-496c-8874-05860f00e086&PID=8a629561-5f41-45ed-92c9-d5bddb2765bd";
//			
//			//String postData = "OperationUserID="+operationUserID+"&LabelID="+labelID+"&FID="+fID+"&PID="+pid;
//			
//			////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//			String postData = "OperationUserID="+DrmGlobalVal.AIP_OPERATIONUSERID+"&LabelID:"+DrmGlobalVal.AIP_LABELID+"&FID="+fID+"&PID="+pid;
//			////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//			
//            String encryptionResult = sendHttpRequest("POST", StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPEncryption/Label", postData, null); // 암호화 method POST
//            
//            JSONParser parser = new JSONParser();
//			Object obj = parser.parse(encryptionResult);
//			
//			JSONObject encryptionResultJson = new JSONObject();
//			encryptionResultJson = (JSONObject) obj;
//			
//			String status = StringUtil.checkNull(encryptionResultJson.get("Status")); // Success : 0, Fail : 1
//			fID = StringUtil.checkNull(encryptionResultJson.get("fID"));
//			String errorMsg = StringUtil.checkNull(encryptionResultJson.get("errorMsg"));
//			String outputFilePath = StringUtil.checkNull(encryptionResultJson.get("outputFilePath"));
//						
//		    System.out.println("=== encryption result status :"+status+", outputFilePath: " + outputFilePath);
//		    if(status.equals("0")) {
//		   
//		    	 URL url = new URL(StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/file/"+fID+"/"+pid);
//		         Path destination = Paths.get(filePath + filename_org);
//		         
//		         // 파일 복사
//		         Files.copy(url.openStream(), destination, StandardCopyOption.REPLACE_EXISTING);
//		         System.out.println("report 암호화 파일 다운로드 완료 : 암호화된 파일 다운로드된 경로  ::"+ filePath + filename_org);
//		    }
//		}
//
//		return filePath + filename_org;
//	}
}