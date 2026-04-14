package xbolt.cmm.framework.util.drm;

import SCSL.SLDsFile;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import java.util.List;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;

public class DRM_SOFTCAMP
{
	static String LegacySystemID = "2WsAas55Im8jv7keL0a5lfXBsH1sy9gt4y/DJVb+6hccSSkx/pFbWnH0R68c108kIEO1Wxyk0vJ890VsuMJr8UigHI5H5HYqiKDq7q12GIBPfIanBR2i1g3JEonh0xAkGsW8Gl5Kbz0lMwU8jeS6V8hAuMcozOfTe89t3cdZroLp0Gu+QxpyZQ==";
	static String RemoteLoginId = "hechbpmnasadm"; //OPS
	static String RemoteLoginPw = "HecNas1!"; //OPS
	// static String RemoteLoginId = "aipgateway"; //DEV
	// static String RemoteLoginPw =  "Qazwsx!@12"; //DEV
	// static String RemoteServer = "\\\\10.176.224.63\\olmfile"; // DEV
	static String RemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\OLMFILE"; // OPS
	//static String ReportRemoteServer = "\\\\10.176.224.63\\OLM3.2"; // DEV
	static String ReportRemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\OLMFILE"; // OPS
	static String UserPrincipalName = "hecSecure@aipgw.com";
	//static String aipUrl = "https://aipgwdev.hec.co.kr/"; //DEV
	static String aipUrl = "https://aipgw.hec.co.kr/"; // OPS
	//static String labelID = "3c381d04-f1ec-4fd7-ac39-91e42085e2b5"; // DEV
	static String labelID = "cdcaf456-5176-400c-b0e6-6301b2c47597"; // OPS
	
	// 허용할 파일 확장자들
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(
            "docx", "docm", "doc", "dotx", "dotm", "dot", "xlsx", "xlsm", "xlsb", "xls",
            "cvs", "xltx", "xlt", "xlam", "xla", "xps", "pptx", "pptm", "ppt", "potx",
            "potm", "pot", "ppsx", "ppsm", "ppa", "pdf"
    );
	
	public static String upload(HashMap drmInfoMap) throws Exception { // 1.DRM 해제, 2.AIP 해제
		String returnValue = "";
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "").replace("//", "\\").replace("/", "\\");
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"), "").replace("//", "\\").replace("/", "\\");
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");

		String userID = StringUtil.checkNull(drmInfoMap.get("userLoginID"), "");
		
		SLDsFile sFile = new SLDsFile();

		sFile.SettingPathForProperty("c:\\softcamp\\02_Module\\02_ServiceLinker\\softcamp.properties");
    
		System.out.println("=======UPload DRM 복호화 ========");
		System.out.println("orgFileDir + FileRealName  :"+ORGFileDir + FileRealName);
		System.out.println("DRMFileDir + Filename :"+DRMFileDir + Filename);
   
		int retVal = sFile.CreateDecryptFileDAC(
				"c:\\softcamp\\04_KeyFile\\keyDAC_SVR0.sc", 
				"SECURITYDOMAIN", 
				ORGFileDir + FileRealName, 
				DRMFileDir + Filename);
    
		System.out.println(" DRM 해제 CreateDecryptFileDAC [" + retVal + "]");
    
		String ext = Filename.substring( Filename.lastIndexOf(".")+1, Filename.length());
		if (ALLOWED_EXTENSIONS.contains(ext)) { // 허용된 확장자만 암호화 되도록 
			String uploadAip = uploadAip(drmInfoMap);
		} else {
			System.out.println("Upload AIP NOT ALLOWED EXTENSIONS :"+ext);
		}
    
		return returnValue;
	}

	public static String download(HashMap drmInfoMap) throws Exception
	{
		String returnValue = "";
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("downFile"), "").replace("//", "\\").replace("/", "\\");
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"), "").replace("//", "\\").replace("/", "\\");
		
		//System.out.println("download donwFile => "+StringUtil.checkNull(drmInfoMap.get("downFile"), ""));
		//System.out.println("download ORGFileDir => "+ORGFileDir );
		
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("orgFileName"));
		String userID = StringUtil.checkNull(drmInfoMap.get("userLoginID"), "");
		String userName = StringUtil.checkNull(drmInfoMap.get("userName"), "");
		String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"), "");
		String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"), "");
    
		SLDsFile sFile = new SLDsFile();
		sFile.SettingPathForProperty("c:\\softcamp\\02_Module\\02_ServiceLinker\\softcamp.properties");

		//int ret = sFile.SLDsEncFileDACV2("c:\\softcamp\\04_KeyFile\\keyDAC_SVR0.sc", "Hway", ORGFileDir, StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH).replace("//", "\\").replace("/", "\\") + "\\" + Filename, 1);
		//System.out.println("SLDsEncFileDAC :" + ret);
		//String drmOutputDir = StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH).replace("//", "\\").replace("/", "\\");
			      
		File dirFile = new File(DRMFileDir); // StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//");
        // 디렉토리와 그 내용물을 모두 삭제
        deleteDirectory(dirFile);
		
		if (!dirFile.exists()) {
			dirFile.mkdirs();
	    }
		
		/*
		System.out.println("=======Download DRM 복호화 ========");
		System.out.println("orgFileDir + FileRealName  :"+ORGFileDir);
		int retVal = sFile.CreateDecryptFileDAC(
    	      "c:\\softcamp\\04_KeyFile\\keyDAC_SVR0.sc", 
    	      "SECURITYDOMAIN",
    	      ORGFileDir, 
    	      DRMFileDir+Filename); // StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//");
		System.out.println("download 복호화 결과값  retVal :"+retVal);
       */
		
		FileUtil.copyFile(ORGFileDir, DRMFileDir+Filename);
		
		String downloadAip = "";
		String ext = Filename.substring( Filename.lastIndexOf(".")+1, Filename.length());
		if (ALLOWED_EXTENSIONS.contains(ext)) { // 허용된 확장자만 암호화 되도록 
			// Aip 암호화 
			drmInfoMap.put("drmOutputDir",DRMFileDir);
			drmInfoMap.put("filePath",DRMFileDir+Filename);
			downloadAip = downloadAip(drmInfoMap);
        } else {
             System.out.println("NOT ALLOWED EXTENSIONS :"+ext);
        }
    
		//System.out.println("downloadAip :" + downloadAip);
		return downloadAip;    
	}

	/////////////////////////////////////////////2023.09 AIP 추가  //////////////////////////////////////////////////////////////////////////////
	// DecryptFile
	public static String uploadAip(HashMap drmInfoMap) throws Exception {
		String filePath = StringUtil.checkNull( drmInfoMap.get("DRMFileDir")).replace("//","\\").replace("/", "\\"); // targetPath
		String fileName = StringUtil.checkNull(drmInfoMap.get("Filename"));
		String result = "";
  	
		//암호화되어 있지 않으면 종료		
		String fileEncryptedStatus = IsLabeledOrProtected(filePath+fileName);
		if(fileEncryptedStatus.equals("0")) { // 0이 아니면 복호화 로직 필수
			return result;
		}
        
		URL url               = null;
		HttpsURLConnection con = null;
		OutputStream os       = null;  
		BufferedReader br     = null;
     
		StringBuilder response = null;
		int status             = 0;
		String strUrl          = "";
		String responseLine    = "";
		
		if (filePath.indexOf("ROOT") != -1) {
			 // "ROOT" 이후의 부분 가져오기
	         String resultString = filePath.substring(filePath.indexOf("ROOT") + "ROOT".length());
	         RemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\ROOT";
	    } else  if (filePath.indexOf("upload") != -1) {	           
	         String resultString = filePath.substring(filePath.indexOf("upload") + "upload".length());
	         RemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\upload";
	    } else {
	         // "ROOT//"이 문자열에 없는 경우에 대한 처리
	    }
	    System.out.println(" RemoteServer :"+RemoteServer);
              
		// Map에 데이터 담기
		Map<String, Object> fileMap = new HashMap<>();
		fileMap.put("LegacySystemID", LegacySystemID); 
		fileMap.put("IsRemote", "true");
		fileMap.put("RemoteLoginId", RemoteLoginId);// 운영 -> hechbpmnasadm
		fileMap.put("RemoteLoginPw", RemoteLoginPw); // 운영 -> HecNas1!
		fileMap.put("userPrincipalName", UserPrincipalName);
		fileMap.put("decryptFlags","0");   
     
		fileMap.put("FilePath", filePath + fileName);        //  fileInfo.setFilePath("\\\\10.10.10.1\\AIPShare\\TestFiles\\SampleFile.xlsx");
		fileMap.put("RemoteServer", RemoteServer); // fileInfo.setRemoteServer("\\\\10.10.10.1\\AIPShare\\TestFiles\\");
		fileMap.put("outputDirectory",filePath); // \\\\10.176.224.63\\olmfile\\document\\FLTP001\\ (예시) 
    
		// Map -> JSON
		JSONObject fileJsonObject = new JSONObject(fileMap);
		String fileJsonOjectString = fileJsonObject.toString();
              
		strUrl =  aipUrl + "RestAPI/api/DecryptFile";
     
		url = new URL(strUrl);
     
		SSLContext ssl = SSLContext.getInstance("TLSv1.2"); 
		ssl.init(null, null, new SecureRandom());
		
	    con = (HttpsURLConnection) url.openConnection();
	    con.setSSLSocketFactory(ssl.getSocketFactory());
	      
	    con.setRequestMethod("PUT");
	    con.setRequestProperty("Content-Type", "application/json; utf-8");
	    con.setRequestProperty("Accept", "application/json");        
	     
	    con.setDoOutput(true);        
	      
	    os = con.getOutputStream();
	      
	    byte[] input = fileJsonOjectString.getBytes("utf-8");
	    os.write(input, 0, input.length);    
	      
	    status = con.getResponseCode();
	    //System.out.println("uploadAip 복호화 status :"+status);
	    if (status == 200) {
	        br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));                
	        response = new StringBuilder();
	          
	        while ((responseLine = br.readLine()) != null) 
	        {
	             response.append(responseLine.trim());
	        }
	    }
	    result = response.toString();
	    // System.out.println("uploadAip aip 복호화 result : "+result);
      
	    return result;
	}
  
	public static String downloadAip(HashMap drmInfoMap) throws Exception {  
		String fileName = StringUtil.checkNull(drmInfoMap.get("Filename"));
		String filePath = StringUtil.checkNull(drmInfoMap.get("filePath")); // drmInfoMap.put("filePath",DRMFileDir+Filename); 
		//System.out.println("downloadAip drmInfoMap :::"+drmInfoMap);

		String drmOutputDir = StringUtil.checkNull(drmInfoMap.get("drmOutputDir"));
	 
	    //암호화되어 있으면 종료
	  	String fileEncryptedStatus = IsLabeledOrProtected(filePath);
		if(fileEncryptedStatus.equals("1") || fileEncryptedStatus.equals("3")) { // 대외비이상 암호화 된파일이면
			return "";
		}
	  	
	    URL url               = null;
	    HttpsURLConnection con = null;
	    OutputStream os       = null;   
	    BufferedReader br     = null;
	     
	    StringBuilder response = null;
	    int status             = 0;
	    String strUrl          = "";
	    String responseLine    = "";
	    // String remoteServer = "\\\\10.176.224.63\\AIPShare\\TestFiles\\";

		if (filePath.indexOf("ROOT") != -1) {
			 // "ROOT" 이후의 부분 가져오기
	         String resultString = filePath.substring(filePath.indexOf("ROOT") + "ROOT".length());
	         RemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\ROOT";
	    } else  if (filePath.indexOf("upload") != -1) {	           
	         String resultString = filePath.substring(filePath.indexOf("upload") + "upload".length());	        
	         RemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\upload";
	    } else {
	         // "ROOT//"이 문자열에 없는 경우에 대한 처리
	    }
	    System.out.println(" RemoteServer :"+RemoteServer);
	
	    // Map에 데이터 담기
	    Map<String, Object> fileMap = new HashMap<>();
	    fileMap.put("LegacySystemID", LegacySystemID);
	    fileMap.put("IsRemote", true);
	    fileMap.put("RemoteLoginId", RemoteLoginId); // 운영 -> hechbpmnasadm
	    fileMap.put("RemoteLoginPw", RemoteLoginPw); // 운영 -> HecNas1!
	    fileMap.put("LabelID", labelID);
	    fileMap.put("userPrincipalName", UserPrincipalName);
	      
	    fileMap.put("FilePath", filePath);        //  fileInfo.setFilePath("\\\\10.10.10.1\\AIPShare\\TestFiles\\SampleFile.xlsx");
	    fileMap.put("RemoteServer", RemoteServer); // fileInfo.setRemoteServer("\\\\10.10.10.1\\AIPShare\\TestFiles\\");
	    fileMap.put("outputDirectory", drmOutputDir); // fileInfo.setOutputDirectory("\\\\10.10.10.1\\AIPShare\\TestFiles\\");
	    fileMap.put("CurrentAdhocProtection", "keep");
	    // Map -> JSON
	    JSONObject fileJsonObject = new JSONObject(fileMap);
	    String fileJsonObjectString = fileJsonObject.toString();
	    
	    //AIP G/W API를 호출하기 위한 API URL입니다.(각 API별 Reqeust 예시 참조)
	    strUrl = aipUrl + "RestAPI/api/Label/UpdateLabel";        
	    url = new URL(strUrl);
	      
		SSLContext ssl = SSLContext.getInstance("TLSv1.2"); 
		ssl.init(null, null, new SecureRandom());
				
	    con = (HttpsURLConnection) url.openConnection();
	    // con.setSSLSocketFactory(ssl.getSocketFactory());
	    	      
	    con.setRequestMethod("PUT");
	    con.setRequestProperty("Content-Type", "application/json; utf-8");
	    con.setRequestProperty("Accept", "application/json");        
	    con.setDoOutput(true);       	     
	    os = con.getOutputStream();
	     
	    byte[] input = fileJsonObjectString.getBytes("utf-8");
	    os.write(input, 0, input.length);                   
	    
	    status = con.getResponseCode();
	    
	    // 1 : Success 결과성공, 9999 : MIP SDK Exception  
	    // System.out.println("downLoad status  :"+status);
	    String encryptedFilePath = "";
	    if (status == 200) {
	        br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));                
	        response = new StringBuilder();
	          
	        while ((responseLine = br.readLine()) != null){
	        	response.append(responseLine.trim());
	        }
	        
	        JSONParser jsonParser = new JSONParser();
			JSONObject object = (JSONObject) jsonParser.parse(response.toString());
			encryptedFilePath = object.get("EncryptedFilePath").toString(); 
			
	        System.out.println("EncryptedFilePath: " + encryptedFilePath);
	     }   
	      
	     System.out.println("download 암호화 response :"+response.toString());
	     //System.out.println("response encryptedFilePath 암호화 완료 경로 + 파일 :"+encryptedFilePath);
	     return encryptedFilePath;
	  }
  
  // report
  public String report(HashMap drmInfoMap) throws Exception {    
	  String fileName = StringUtil.checkNull(drmInfoMap.get("orgFileName"));
	  String filePath = StringUtil.checkNull(drmInfoMap.get("downFile")).replace("//","\\").replace("/", "\\"); 
  	  if(filePath.equals("")){ filePath = StringUtil.checkNull(FileUtil.FILE_EXPORT_DIR).replace("//","\\").replace("/", "\\"); }
  	
  	  // String filePath = "\\\\10.176.224.63\\OLM3.2\\webapps\\ROOT\\doc\\export\\";
  	  // DRM_DECODING_FILEPATH = ////10.6.104.249//share_483033ce_0b9b_43a9_9b63_0ba43e7e2902//OLMFILE//document//DRM//
  	  String outputDirectory = StringUtil.checkNull(GlobalVal.FILE_EXPORT_DIR).replace("//","\\").replace("/", "\\") + StringUtil.checkNull(drmInfoMap.get("userID")) + "\\"; 
  	  	
      URL url               = null;
      HttpsURLConnection con = null;
      OutputStream os       = null;   
      BufferedReader br     = null;
      
      StringBuilder response = null;
      int status             = 0;
      String strUrl          = "";
      String responseLine    = "";
      
      if (filePath.indexOf("ROOT") != -1) {
			 // "ROOT" 이후의 부분 가져오기
	         String resultString = filePath.substring(filePath.indexOf("ROOT") + "ROOT".length());
	         ReportRemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\ROOT";
	    } else  if (filePath.indexOf("upload") != -1) {	           
	         String resultString = filePath.substring(filePath.indexOf("upload") + "upload".length());
	         ReportRemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\upload";
	    } else {
	         // "ROOT//"이 문자열에 없는 경우에 대한 처리
	    }
	    System.out.println(" ReportRemoteServer :"+ReportRemoteServer);

      // Map에 데이터 담기
      Map<String, Object> fileMap = new HashMap<>();
      fileMap.put("LegacySystemID", LegacySystemID);
      fileMap.put("IsRemote", "true");
      fileMap.put("RemoteLoginId", RemoteLoginId); // 운영 -> // fileMap.put("RemoteLoginId", "aipgateway");
      fileMap.put("RemoteLoginPw", RemoteLoginPw); // 운영 -> // fileMap.put("RemoteLoginPw", "Qazwsx!@12");
      fileMap.put("LabelID", labelID);
      fileMap.put("userPrincipalName", UserPrincipalName);
      
      fileMap.put("FilePath", filePath);        //  fileInfo.setFilePath("\\\\10.10.10.1\\AIPShare\\TestFiles\\SampleFile.xlsx");
      fileMap.put("RemoteServer", ReportRemoteServer); // fileInfo.setRemoteServer("\\\\10.10.10.1\\AIPShare\\TestFiles\\");
      fileMap.put("outputDirectory", outputDirectory); // fileInfo.setOutputDirectory("\\\\10.10.10.1\\AIPShare\\TestFiles\\");
      fileMap.put("CurrentAdhocProtection", "keep");

      // Map -> JSON
      JSONObject fileJsonObject = new JSONObject(fileMap);
      String fileJsonObjectString = fileJsonObject.toString();
      
      //System.out.println("SetLabel fileJsonObjectString :"+fileJsonObjectString);
      //AIP G/W API를 호출하기 위한 API URL입니다.(각 API별 Reqeust 예시 참조)
      strUrl = aipUrl + "RestAPI/api/Label/UpdateLabel";        
      url = new URL(strUrl);
      
	  SSLContext ssl = SSLContext.getInstance("TLSv1.2"); 
	  ssl.init(null, null, new SecureRandom());
		
      con = (HttpsURLConnection) url.openConnection();
     // con.setSSLSocketFactory(ssl.getSocketFactory());
      
      con.setRequestMethod("PUT");
      con.setRequestProperty("Content-Type", "application/json; utf-8");
      con.setRequestProperty("Accept", "application/json");        
      con.setDoOutput(true);        
      
      os = con.getOutputStream();
      
      byte[] input = fileJsonObjectString.getBytes("utf-8");
      os.write(input, 0, input.length);                   
      
      status = con.getResponseCode();
      
      String encryptedFilePath = "";
      // 1 : Success 결과성공, 9999 : MIP SDK Exception  
      if (status == 200) {
          br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));                
          response = new StringBuilder();
          
          while ((responseLine = br.readLine()) != null) 
          {
              response.append(responseLine.trim());
          }
          System.out.println("report  aip 암호화 완료 !!!response :"+response); 
          JSONParser jsonParser = new JSONParser();
		  JSONObject object = (JSONObject) jsonParser.parse(response.toString());
		  encryptedFilePath = object.get("EncryptedFilePath").toString(); 
      }       
      
      return encryptedFilePath;
  }
  
  // 암화화 확인 
  public static String IsLabeledOrProtected(String filePath) throws Exception {
	  String fileEncryptedStatus = "";
  	
      StringBuffer sb       = null;
      StringBuilder resSb   = null;
      URL url               = null;
      HttpsURLConnection con = null;        
      
      BufferedReader br  = null;
      int status         = 0;
      String strReqParam = "";
      String strUrl      = "";
      
      if (filePath.indexOf("ROOT") != -1) {
    	  // "ROOT" 이후의 부분 가져오기
    	  String resultString = filePath.substring(filePath.indexOf("ROOT") + "ROOT".length());
    	  RemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\ROOT";
      } else  if (filePath.indexOf("upload") != -1) {	           
         String resultString = filePath.substring(filePath.indexOf("upload") + "upload".length());
         RemoteServer = "\\\\10.6.104.249\\share_483033ce_0b9b_43a9_9b63_0ba43e7e2902\\upload";
      } else {
         // "ROOT//"이 문자열에 없는 경우에 대한 처리
      }
      System.out.println(" RemoteServer :"+RemoteServer);
      
     // String remoteServer = "\\\\10.176.224.63\\AIPShare\\TestFiles\\";
      Map<String, String> params = new HashMap<String, String>();
      
      params.put("LegacySystemID", URLEncoder.encode(LegacySystemID, "UTF-8"));
      params.put("IsRemote",       URLEncoder.encode("true", "UTF-8"));
      params.put("RemoteLoginId",  RemoteLoginId);// 운영-> hechbpmnasadm
      params.put("RemoteLoginPw",  RemoteLoginPw);// 운영 -> HecNas1!
      params.put("FilePath",      URLEncoder.encode(filePath, "UTF-8"));     // params.put("FilePath", URLEncoder.encode(\\\\10.10.10.1\\AIPShare\\TestFiles\\SampleFile.xlsx, "UTF-8"));
      params.put("RemoteServer",  URLEncoder.encode(RemoteServer, "UTF-8")); // params.put("RemoteServer",  URLEncoder.encode("\\\\10.10.10.1\\AIPShare\\TestFiles\\", "UTF-8"));

      sb = new StringBuffer();
      
      for (String key : params.keySet()) 
      {
        if (sb.length() > 0) 
        {
            sb.append("&");
        }
        sb.append(key);
        sb.append("=");
        sb.append(params.get(key));
      }
              
      strReqParam = sb.toString();      
      
      strUrl =  aipUrl + "RestAPI/api/IsLabeledOrProtected?" + strReqParam;

      url = new URL(strUrl);
      
		SSLContext ssl = SSLContext.getInstance("TLSv1.2"); 
		ssl.init(null, null, new SecureRandom());
		
      con = (HttpsURLConnection) url.openConnection();
      con.setSSLSocketFactory(ssl.getSocketFactory());
      con.setRequestMethod("GET");        
      con.setRequestProperty("Content-Type", "application/json; utf-8");
      status = con.getResponseCode();
      
      if (status == 200) {
          br = new BufferedReader(new InputStreamReader(con.getInputStream()));
          resSb = new StringBuilder();
          String line = "";

          while ((line = br.readLine()) != null) {
              resSb.append(line);
          }            
      }        
           
      try {
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject) parser.parse(resSb.toString());
			fileEncryptedStatus = object.get("FileEncryptedStatus").toString(); // 0: 적용안됨
			
			/*
			0 : None (레이블과 암호화 모두 적용안됨) → 0이 아니면 AIP 복호화(DecryptFile) 로직 필수 
			1 : Protected (레이블 없이 암호화만 적용됨)
			2 : Labeled (암호화 없이 레이블만 적용됨)
			3 : LabelWithProtected (레이블과 암호화 모두 적용됨) */
			
			System.out.println("IsLabeledOrProtected object :"+object);
			System.out.println("IsLabeledOrProtected FileEncryptedStatus :"+fileEncryptedStatus);
			
      }
      catch(ParseException e) {
      	System.out.println(e);
      }
  	return fileEncryptedStatus;
  }
  
  public static void deleteDirectory(File dir) {
      if (dir.isDirectory()) {
          File[] children = dir.listFiles();
          if (children != null) {
              for (File child : children) {
                  deleteDirectory(child);
              }
          }
      }
      // 비어있는 디렉토리나 파일 삭제
      dir.delete();
  }
}