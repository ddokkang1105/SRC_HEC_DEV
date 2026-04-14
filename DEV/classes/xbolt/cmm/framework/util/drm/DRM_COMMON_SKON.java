package xbolt.cmm.framework.util.drm;

import java.io.File;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

import xbolt.cmm.framework.handler.ApplicationContextProvider;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.service.CommonService;

/**
 * CJGLOBAL File DRM 적용
 * 
 * @Class Name : DRMUtil.java
 * @Description : CJ File DRM 적용 관련 함수
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2017. 04.
 *      28. smartfactory 최초생성
 *
 * @since 2017. 04. 28.
 * @version 1.0
 * @see
 * 
 *      Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class DRM_COMMON_SKON {

	/* UPLOAD 작업 */
	@SuppressWarnings("unchecked")
	public static String upload(HashMap drmInfoMap) throws ExceptionUtil {

		String returnVal = "";

		try {
			
			boolean a = checkFasooUser(drmInfoMap);
			
			String orgFilePath = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "")
					+ StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");

			String targetPath = StringUtil.checkNull(DrmGlobalVal.DRM_FASOO_DECODING_FILEPATH)
					+ StringUtil.checkNull(drmInfoMap.get("userID")) + "//";;
				String targetFileName = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
				
				String targetFilePath = targetPath + targetFileName;
				
			// 중국 지사 FASOO & SOFTCAMP 적용
			if (checkFasooValidation(orgFilePath)) {

					
				// 폴더 초기화
				createNewUserDirectory(targetPath);

				// File 복제
				copyFile(orgFilePath, targetPath, targetFileName);

				// Fasoo 복호화

				System.out.println(
						"*****************************************************************************************");
				System.out.println("Fasoo 복호화 진행 시작");
				System.out.println();

				getHeaderFile(targetFilePath);

				returnVal = DRM_FASOO_SKON.upload(drmInfoMap);

				getHeaderFile(targetFilePath);

				// SoftCamp DRM에 변수 변경
				drmInfoMap.put("ORGFileDir", StringUtil.checkNull(targetPath));
				drmInfoMap.put("FileRealName", StringUtil.checkNull(drmInfoMap.get("Filename"), ""));

				System.out.println();
				System.out.println("----------------------------------");
				System.out.println("Fasoo -> SoftCamp");
				System.out.println("----------------------------------");
				System.out.println();
				
			}

			// SoftCamp 암호화
			System.out.println();
			System.out.println("SoftCamp 암호화 진행 시작");
			System.out.println();

			returnVal = DRM_SOFTCAMP_SKON.upload(drmInfoMap);

			System.out.println();
			System.out.println(
					"*****************************************************************************************");

		} catch (Exception e) {
			throw new ExceptionUtil();
		}

		return returnVal.toString();
	}

	/* DOWNLOAD 작업 */
	@SuppressWarnings("unchecked")
	public static String download(HashMap drmInfoMap) throws ExceptionUtil {

		String returnVal = "";

		try {
			// 중국 지사 FASOO & SOFTCAMP 적용
			if (checkFasooUser(drmInfoMap)) {

				// SoftCamp 복호화
				String orgFilePath = StringUtil.checkNull(drmInfoMap.get("downFile"), "").replace("//", "\\")
						.replace("/", "\\");
				String targetPath = StringUtil.checkNull(DrmGlobalVal.DRM_FASOO_DECODING_FILEPATH) 
						+ StringUtil.checkNull(drmInfoMap.get("userID")) + "//";;
				String targetFileName = StringUtil.checkNull(drmInfoMap.get("orgFileName"), "");
				
				String targetFilePath = targetPath + targetFileName;
				
				// 폴더 초기화
				createNewUserDirectory(targetPath);

				// File 복제
				copyFile(orgFilePath, targetPath, targetFileName);

				
				System.out.println(
						"*****************************************************************************************");
				System.out.println("SoftCamp 복호화 진행 시작");
				System.out.println();

				returnVal = DRM_SOFTCAMP_SKON.download(drmInfoMap);


				System.out.println();
				System.out.println("----------------------------------");
				System.out.println("SoftCamp -> Fasoo");
				System.out.println("----------------------------------");
				System.out.println();

				// Fasoo 암호화
				System.out.println("Fasoo 암호화 진행 시작");
				
				// FASOO DRM에 변수 변경
				drmInfoMap.put("downFile", StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH).replace("//", "\\").replace("/","\\")
						+ "\\"
						+ StringUtil.checkNull(targetFileName, ""));
				drmInfoMap.put("targetFile", StringUtil.checkNull(targetFilePath, ""));
				
				getHeaderFile(targetFilePath);

				returnVal = DRM_FASOO_SKON.download(drmInfoMap);

				getHeaderFile(targetFilePath);

				System.out.println();
				System.out.println("*****************************************************************************************");

			}
			// SKON SOFTCAMP 적용
			else {

				if ((DrmGlobalVal.DRM_SOFTCAMP_DOWN_USE).equals("Y")) {
					// SoftCamp 암호화
					returnVal = DRM_SOFTCAMP_SKON.download(drmInfoMap);
				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil();
		}
		return returnVal.toString();
	}

	/* VIEW 작업 */
	public static String view(HashMap drmInfoMap) throws ExceptionUtil {

		String returnVal = "";
		String orgFilePath = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "").replace("//", "\\").replace("/", "\\")
					+ StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");
		if(checkFasooValidation(orgFilePath)) {
			returnVal = DRM_FASOO_SKON.view(drmInfoMap);
		}else {
			returnVal = DRM_SOFTCAMP_SKON.view(drmInfoMap);
		}
		

		return returnVal.toString();
	}

	public static boolean checkFasooValidation(String fileFullPath) throws ExceptionUtil {

		boolean isFasoo = DRM_FASOO_SKON.isFasooFile(fileFullPath);
		
		System.out.println();
		System.out.println("Fasoo 파일 여부 : " + isFasoo);
		System.out.println("Fasoo 파일 path : " + fileFullPath);
		System.out.println();
		

		return isFasoo;
	}

	public static void copyFile(String orginFilePath, String targetPath, String targetFileName) throws ExceptionUtil {

		try {
			
			
			System.out.println();
			System.out.println("ORG FILEPATH : " + orginFilePath);
			System.out.println("TAR FILEPATH : " + targetPath + targetFileName);
			System.out.println();
			
			File orginFullPath = new File(orginFilePath);
			File targetFullPath = new File(targetPath + targetFileName);

			FileUtil.copyFile(orginFilePath, targetPath + targetFileName);
			//Files.copy(orginFullPath.toPath(), targetFullPath.toPath());
			
			System.out.println("DRM TMP 파일 복사 성공");

		} catch (Exception e) {
			System.out.println("DRM TMP 파일 복사 실패");
			e.printStackTrace();
		}
	}

	public static void getHeaderFile(String filePath) throws ExceptionUtil {

		Hashtable headerInfo = DRM_FASOO_SKON.getFileHeader(filePath);

	}

	public static boolean checkFasooUser(HashMap drmInfoMap) throws ExceptionUtil{

		boolean isFasooUser = false;

		try {
			
			String userID = StringUtil.checkNull(drmInfoMap.get("userID"), "");
			
			Map<String, Object> userMap = new HashMap<String, Object>();
			userMap.put("sessionUserId", userID);
			
			CommonService commonService = ApplicationContextProvider.getApplicationContext().getBean("commonService", CommonService.class);
			String clientID = StringUtil.checkNull(commonService.selectString("user_SQL.userClientID", userMap));
			
			if(clientID.equals("SKOJ")) isFasooUser = true;

			//isFasooUser = (DrmGlobalVal.DOC_DOWNLOAD_FASOO_YN).equals("Y");

			System.out.println();
			System.out.println("Fasoo User ID : " + userID);
			System.out.println("Fasoo Client ID : " + clientID);
			System.out.println("Fasoo User 여부 : " + isFasooUser);
			System.out.println();
			
		}catch(Exception e) {
			
			System.out.println("Client ID 조회 실패");
			e.printStackTrace();
		}
		return isFasooUser;
	}
	
	public static void createNewUserDirectory(String path) throws ExceptionUtil {
		
		try {
			
			File targetFolder = new File(path);
			
			if(targetFolder.exists()) {
				FileUtil.deleteDirectory(path);
			}
			targetFolder.mkdir();
			
			System.out.println("DRM TMP 폴더 삭제 및 생성 성공");
			
		}catch(Exception e) {
			
			System.out.println("DRM TMP 폴더 삭제 및 생성 실패");

			e.printStackTrace();
		}

	}
}
