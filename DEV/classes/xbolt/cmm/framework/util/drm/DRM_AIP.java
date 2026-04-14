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
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
//import com.org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

@SuppressWarnings("unused")
public class DRM_AIP {
	public static String report(HashMap drmInfoMap) throws Exception {
		String returnValue = "";
		
		String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"),"");
		if(filePath.equals("")){
			filePath = FileUtil.FILE_EXPORT_DIR;
		}
		
		String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName
		
		// 암호화
		String url = StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPP/SetSensitivityLabel  ";
		String key = "Result";
		String reqeustStr = "{\"SystemId\":\""+StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)+"\",\"Path\":\""+filePath+"\",\"FileName\":\""+filename_org+"\",\"LabelId\":\"6b89535c-2ba5-4f71-a34a-075d8392d04a\"}";
		sendAPI(url, reqeustStr, key);
		System.out.println("=== AIP Report SetSensitivityLabel reqeust == "+reqeustStr);
		
		returnValue = filePath + StringUtil.checkNull(drmInfoMap.get("orgFileName"));
		return returnValue;
	}
	
	/* 복호화 작업 */
	public static String upload(HashMap drmInfoMap) {
		String returnValue = "";
		
		
		try {
			// 복호화 확인하기위해 복호화 폴더로 파일 복사
			String filePath = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH);
			String filename = StringUtil.checkNull(drmInfoMap.get("Filename"));
			String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),""); // 암호화 대상 문서 FullPath
			FileUtil.copyFile(ORGFileDir+filename, StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH)+filename);
						
			String url = StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPP/IsFileEncrypted";
			String key = "IsAIPEncrypted";
			String reqeustStr = "{\"SystemId\":\""+StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)+"\",\"Path\":\""+filePath.substring(0,filePath.length()-1) +"\",\"FileName\":\""+filename+"\"}";
			System.out.println("=== AIP Upload IsFileEncrypted reqeust == "+reqeustStr);
			
			// 암호화 여부 확인
			if(sendAPI(url, reqeustStr, key)) {
				// 복호화
				url = StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPP/RemoveSensitivityLabel ";
				key = "Result";
				reqeustStr = "{\"SystemId\":\""+StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)+"\",\"Path\":\""+filePath.substring(0,filePath.length()-1)+"\",\"FileName\":\""+filename+"\"}";
				System.out.println("=== AIP Upload RemoveSensitivityLabel reqeust == "+reqeustStr);
				if(sendAPI(url, reqeustStr, key)) {
					FileUtil.copyFile(StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH)+filename, ORGFileDir+filename);
				}
			}
			
			FileUtil.deleteFile(DrmGlobalVal.DRM_DECODING_FILEPATH+filename);
		} catch (Exception e) {
			System.out.println(e.getStackTrace());
		}
	  	return returnValue;
	}
	
	public static String download(HashMap drmInfoMap) throws Exception {
		
		String filename = StringUtil.checkNull(drmInfoMap.get("Filename")); // filename
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"),""); // 암호화 대상 문서 FullPath
		FileUtil.copyFile(ORGFileDir+filename, StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH)+filename);
		String filePath = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH);
		
		String returnValue = "";
		String url = StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPP/IsFileEncrypted";
		String key = "IsAIPEncrypted";
		String reqeustStr = "{\"FileName\":\""+filename+"\",\"Path\":\""+filePath.substring(0,filePath.length()-1)+"\",\"SystemId\":\""+StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)+"\"}";
		System.out.println("=== AIP Download IsFileEncrypted reqeust == "+reqeustStr);
		
		// 암호화 여부 확인
		if(!sendAPI(url, reqeustStr, key)) {
			// 암호화
			url = StringUtil.checkNull(DrmGlobalVal.AIP_SVR_ADDR) + "/api/AIPP/SetSensitivityLabel  ";
			key = "Result";
			reqeustStr = "{\"SystemId\":\""+StringUtil.checkNull(DrmGlobalVal.AIP_SYS_ID)+"\",\"Path\":\""+filePath.substring(0,filePath.length()-1)+"\",\"FileName\":\""+filename+"\",\"LabelId\":\"6b89535c-2ba5-4f71-a34a-075d8392d04a\"}";
			System.out.println("=== AIP Download SetSensitivityLabel reqeust == "+reqeustStr);
			if(sendAPI(url, reqeustStr, key)) {
				FileUtil.copyFile(StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH)+filename, ORGFileDir+filename);
			}
		}
		
		FileUtil.deleteFile(DrmGlobalVal.DRM_DECODING_FILEPATH+filename);
		return ORGFileDir+filename;
	}
	
	private static boolean sendAPI(String apiUrl, String parameters, String getKey) throws Exception {
		JSONObject result = new JSONObject();
		try {
			String body = parameters;
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Accept", "application/json");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			// Redirect처리 하지 않음
			conn.setInstanceFollowRedirects(false);
			
			// Request Body에 Data를 담기위해 OutputStream 객체를 생성.
			OutputStream os= conn.getOutputStream();
			// Request Body에 Data 셋팅.
			byte request_data[] = body.getBytes("utf-8");
			os.write(request_data);
			os.flush();
			os.close();
			
			int responseCode = conn.getResponseCode();
			
			 if (responseCode == 400) {
			    System.out.println("400:: 해당 명령을 실행할 수 없음 ");
			} else if (responseCode == 401) {
			    System.out.println("401:: X-Auth-Token Header가 잘못됨");
			} else if (responseCode == 500) {
			    System.out.println("500:: 서버 에러, 문의 필요");
			} else if (responseCode == conn.HTTP_OK){
			    BufferedReader br = null;
			    String line = "";
			    StringBuilder sb = new StringBuilder();
			    
			    try {
			    	br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
				    while ((line = br.readLine()) != null) {
				        sb.append(line);
				    }
			    } catch ( Exception e ) {
		        	System.out.println(e.toString());
		        	throw e;
		        } finally {
		        	br.close();
		        }
			    
			    line = sb.toString();
			    
				JSONParser parser = new JSONParser();
				Object obj = parser.parse(line);
				result = (JSONObject) obj;
			    System.out.println("=== return Key is "+getKey+" == "+result.get(getKey));
			}
		} catch(IOException e) {
			System.out.println("IOException "+e.getCause());
			e.printStackTrace();
		} catch(Exception e) {
			System.out.println("Exception "+e.getCause());
			e.printStackTrace();
		}
		return (boolean) result.get(getKey);
 	}
}