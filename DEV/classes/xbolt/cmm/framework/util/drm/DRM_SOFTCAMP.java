package xbolt.cmm.framework.util.drm;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import xbolt.cmm.framework.util.*;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.framework.val.DrmGlobalVal;
import SCSL.*;

import com.fasoo.fcwpkg.packager.*;

/**
 * MANDO/HEC/KEFICO/DLE&C File DRM SoftCamp
 * @Class Name : DRM_SOFTCAMP.java
 * @Description : 
 * @Modification Information
 * @---------	---------	-------------------------------
 * @2025. 1. 30. smartfactory		
 *
 * @since 2021. 11. 30.
 * @version 1.0
 * @see
 * 
 */
@SuppressWarnings("unused")
public class DRM_SOFTCAMP {	
		
	/* DRM 업로드 */
	public static String upload(HashMap drmInfoMap) throws ExceptionUtil {
		
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"),""); //원본 파일 위치
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),""); //암호 해제 파일 위치
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"),"");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"),"");
		
		String userID = StringUtil.checkNull(drmInfoMap.get("userID"),"");
		String userName = StringUtil.checkNull(drmInfoMap.get("userName"),"");
		String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"),"");
		String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"),"");
						
		SLDsFile sFile = new SLDsFile();
		sFile.SettingPathForProperty(DrmGlobalVal.DRM_SOFTCAMP_MODULE_PATH); 
		
		int retVal = sFile.CreateDecryptFileDAC (
					DrmGlobalVal.DRM_SOFTCAMP_KEY, "SECURITYDOMAIN", 
					ORGFileDir.replace("//","\\").replace("/", "\\")+FileRealName, 
					DRMFileDir.replace("//","\\").replace("/", "\\")+Filename);
				
					System.out.println( " CreateDecryptFileDAC [" + retVal + "]");	
					return DRMFileDir+Filename;
	   }
	
	/* DRM 다운로드 */
	public static String download(HashMap drmInfoMap) throws ExceptionUtil {
		String returnValue = "";		
		
		System.out.println("start");		
				
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("downFile"),"").replace("//","\\").replace("/", "\\"); 
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),"").replace("//","\\").replace("/", "\\"); // �븫�샇�솕 �셿猷뚮맂 臾몄꽌 FullPath
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"),"");
		
		String userID = StringUtil.checkNull(drmInfoMap.get("userID"),"");
		String userName = StringUtil.checkNull(drmInfoMap.get("userName"),"");
		String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"),"");
		String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"),"");
			
		SLDsFile sFile = new SLDsFile();
		sFile.SettingPathForProperty(DrmGlobalVal.DRM_SOFTCAMP_MODULE_PATH); 		
		sFile.SLDsInitDAC();                                                 
		sFile.SLDsAddUserDAC("SECURITYDOMAIN", "111001100", 0, 0, 0);
		
		int ret;
		ret = sFile.SLDsEncFileDACV2(DrmGlobalVal.DRM_SOFTCAMP_KEY, "System", 
				ORGFileDir, 
				StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH).replace("//","\\").replace("/", "\\") + "\\" + Filename, 1);                             
	
		System.out.println("SLDsEncFileDAC :" + ret);	 
		return StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + "//" + Filename;
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
		
}
