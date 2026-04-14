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

import com.fasoo.adk.packager.*;

/**
 * CJGLOBAL File DRM 적용
 * @Class Name : DRMUtil.java
 * @Description : CJ File DRM 적용 관련 함수 
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2017. 04. 28. smartfactory		최초생성
 *
 * @since 2017. 04. 28.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class DRM_FASOO_CJ {	
	
	public static Map report(HashMap drmInfoMap) throws ExceptionUtil {
		System.out.println("FASOO_CJ == report");
		Map returnMap = new HashMap();
		
		boolean bret = false;
		boolean nret = false;
		boolean iret = false; 
		int fileType = 0;
		try {				
			String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"),"");
			if(filePath.equals("")){
				filePath = FileUtil.FILE_EXPORT_DIR;
			}
			
			String fsdinit = DrmGlobalVal.DRM_DECODING_FILEPATH;
			String dsdcode =  DrmGlobalVal.DRM_KEY_ID;
			
			String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName2
			String filename_tar = StringUtil.checkNull(drmInfoMap.get("orgFileName")); //orgFileName2
			String orgfile = StringUtil.checkNull(drmInfoMap.get("downFile")); //downFile2
			String targetfile =  filePath + filename_tar;
			String securitycode = "1"; //그룹한 등급
			
			WorkPackager wPackager = new WorkPackager();
			
			//복호화 된문서가 암호화된 문서 덮어쓰기 true/false
			wPackager.setOverWriteFlag(true);
			
			//01.암호화 대상 문서가 지원 가능 확장자인지 확인
			nret = wPackager.IsSupportFile( 
											fsdinit,		//fsdinit 폴더 FullPath 설정
			                                dsdcode,		//고객사 Key(default) 
			                                orgfile			//복호화 대상 문서 FullPath + FileName
											); 
			//02.대상 파일의 암호화 여부 확인
			fileType = wPackager.GetFileType(orgfile);
			
			System.out.println("파일형태는 " + FileTypeStr(fileType) + ", fileType :"+fileType);
						
			String userID = StringUtil.checkNull(drmInfoMap.get("userID"));
			String userName = StringUtil.checkNull(drmInfoMap.get("userName"));
			String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"));
			String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"));
			
			//03.대상 문서가 비 암호화 문서 이며 지원 가능 확장자 일때 암호화 진행
			if(fileType == 29){
			//파일 암호화
				iret = wPackager.DoPackagingFsn2( 
											  fsdinit,							//fsdinit 폴더 FullPath 설정
											  dsdcode,							//고객사 Key(default) , 계열사에 맞는 DSD코드 입력
											  orgfile,							//암호화 대상 문서 FullPath + FileName
											  targetfile,						//암호화 된 문서 FullPath + FileName
											  filename_org,						//파일 명
											  userID,							//신청자 ID
											  userName,							//신청자 명
											  userID,userName,teamID,teamName, 	//신청자 ID, 신청자 명, 부서코드, 부서명
											  userID,userName,teamID,teamName, 	//신청자 ID, 신청자 명, 부서코드, 부서명
											  "1"						//그룹 공통 코드 
											  );
	
				System.out.print("암호화 결과값 : " + iret);
				System.out.print(", 오류코드 : " + wPackager.getLastErrorNum());
				System.out.println(", 오류값 : " + wPackager.getLastErrorStr());
			}
			
			returnMap.put("fileType",fileType);
			returnMap.put("drmResultData",iret);
			returnMap.put("errNum",wPackager.getLastErrorNum());
			returnMap.put("errData",wPackager.getLastErrorStr());
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		System.out.println("repot returnMap == "+returnMap);
		return returnMap;
	}
	
	public  static String FileTypeStr(int i) 
	{
		String ret = null;
		switch(i)
		{
	    	case 20 : ret = "파일을 찾을 수 없습니다."; break;
	    	case 21 : ret = "파일 사이즈가 0 입니다.";  break;
	    	case 22 : ret = "파일을 읽을 수 없습니다."; break;
	    	case 29 : ret = "암호화 파일이 아닙니다.";  break;
	    	case 26 : ret = "FSD 파일입니다.";       	break;
	    	case 105: ret = "Wrapsody 파일입니다.";  	break;
	    	case 106: ret = "NX 파일입니다.";			break;	    	
	    	case 101: ret = "MarkAny 파일입니다.";   	break;
	    	case 104: ret = "INCAPS 파일입니다.";    	break;
	    	case 103: ret = "FSN 파일입니다.";       	break;
		}
		return ret;		
	}
	
	/* DRM 복호화 작업 */
	public static String upload(HashMap drmInfoMap) throws ExceptionUtil {
		String returnValue = "";

		String drm_fsdinit_path = DrmGlobalVal.DRM_DECODING_FILEPATH;
		String fsn_domain_id =  DrmGlobalVal.DRM_KEY_ID;	// 고유 코드	
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"),"");
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"),"");					
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"),"");
		
		System.out.println("drm_fsdinit_path :"+drm_fsdinit_path);
		System.out.println("fsn_domain_id :"+fsn_domain_id);

		String sErrMessage = "";
		int error_num = 0;
		String error_str = "";
		int Error_Check = 0;
		String Error_Message = "";
		WorkPackager oWorkPackager = new WorkPackager();
		int iBret = 0;
		
		iBret = oWorkPackager.GetFileType(DRMFileDir+Filename);		// 파일 타입 체크
	
		if (iBret == 103 || iBret == 106) {			// 암호화 문서(FSN Type)일 경우 복호화		 
			boolean bRet = false;		 	    
	 		bRet = oWorkPackager.DoExtract(drm_fsdinit_path, fsn_domain_id, DRMFileDir+Filename, ORGFileDir+Filename);
			error_num = oWorkPackager.getLastErrorNum();
			error_str = oWorkPackager.getLastErrorStr();
		 	  
			if (error_num!=0){
				System.out.println("error_num = ? " + error_num);
				System.out.println("error_str = ?[ " + error_str+" ]");
	
				Error_Check = 1;
				Error_Message = "DRM_PKGING_ERROR";
			}else{
		 		System.out.println("FSN 문서 복호화");
		 		System.out.println("DoExtract Success!!! ");
			}
		} else {
			Error_Check = 1;
			Error_Message = "NOT Support File";
		} 
	  	return returnValue;
	}
	
	/* DRM 암호화 작업 */
	public static String download(HashMap drmInfoMap) throws ExceptionUtil {
		System.out.println("FASOO_CJ == download");
		String returnValue = "";
		
		boolean bret = false;
		boolean nret = false;
		boolean iret = false; 
		int fileType = 0;
		try {
			String fsdinit = DrmGlobalVal.DRM_DECODING_FILEPATH;
			String dsdcode = DrmGlobalVal.DRM_KEY_ID;
			
			String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName
			String orgfile = StringUtil.checkNull(drmInfoMap.get("downFile")); //downFile
			String targetfile =  FileUtil.FILE_EXPORT_DIR + filename_org;
			String securitycode = "1"; //그룹한 등급
			
			WorkPackager wPackager = new WorkPackager();
			
			//복호화 된문서가 암호화된 문서 덮어쓰기 true/false
			wPackager.setOverWriteFlag(true);
			
			//01.암호화 대상 문서가 지원 가능 확장자인지 확인
			nret = wPackager.IsSupportFile( 
											fsdinit,		//fsdinit 폴더 FullPath 설정
			                                dsdcode,		//고객사 Key(default) 
			                                orgfile			//복호화 대상 문서 FullPath + FileName
											); 
			//02.대상 파일의 암호화 여부 확인
			fileType = wPackager.GetFileType(orgfile);
			
			System.out.println("파일형태는 " + FileTypeStr(fileType) + ", fileType :"+fileType);	 
			
			String userID = StringUtil.checkNull(drmInfoMap.get("userID"));
			String userName = StringUtil.checkNull(drmInfoMap.get("userName"));
			String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"));
			String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"));
			
			//03.대상 문서가 비 암호화 문서 이며 지원 가능 확장자 일때 암호화 진행
			if(fileType == 29){
			//파일 암호화
				iret = wPackager.DoPackagingFsn2( 
											  fsdinit,							//fsdinit 폴더 FullPath 설정
											  dsdcode,							//고객사 Key(default) , 계열사에 맞는 DSD코드 입력
											  orgfile,							//암호화 대상 문서 FullPath + FileName
											  targetfile,						//암호화 된 문서 FullPath + FileName
											  filename_org,						//파일 명
											  userID,							//신청자 ID
											  userName,							//신청자 명
											  userID,userName,teamID,teamName, 	//신청자 ID, 신청자 명, 부서코드, 부서명
											  userID,userName,teamID,teamName, 	//신청자 ID, 신청자 명, 부서코드, 부서명
											  "1"						//그룹 공통 코드 
											  );
	
				System.out.println("암호화 결과값 : " + iret);
				
				if(iret) {
					returnValue = targetfile;
					System.out.println("targetfile : " + targetfile);
				} else {
					System.out.println(", 오류코드 : " + wPackager.getLastErrorNum());
					System.out.println(", 오류값 : " + wPackager.getLastErrorStr());
				}
			}
			System.out.println("returnValue : " + returnValue);
			
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return returnValue;
	}
	
	
}
