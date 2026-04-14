package xbolt.cmm.framework.util.drm;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

import com.fasoo.adk.packager.WorkPackager;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;

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
public class DRM_FASOO_SKON {

	/* DRM 복호화 작업 */
	public static String upload(HashMap drmInfoMap) throws ExceptionUtil {
		System.out.println("FASOO_SKON == upload");
		String returnValue = "";

		String drm_fsdinit_path = DrmGlobalVal.DRM_FASOO_MODULE_PATH;
		String fsn_domain_id = DrmGlobalVal.DRM_FASOO_KEY_ID; // 고유 코드
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "");
		String DRMFileDir = DrmGlobalVal.DRM_FASOO_DECODING_FILEPATH 
				+ StringUtil.checkNull(drmInfoMap.get("userID")) + "//";;
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");

		System.out.println("drm_fsdinit_path :" + drm_fsdinit_path);
		System.out.println("fsn_domain_id :" + fsn_domain_id);

		String sErrMessage = "";
		int error_num = 0;
		String error_str = "";
		int Error_Check = 0;
		String Error_Message = "";

		WorkPackager oWorkPackager = new WorkPackager();
		oWorkPackager.setOverWriteFlag(true);

		int iBret = 0;

		iBret = oWorkPackager.GetFileType(ORGFileDir + FileRealName); // 파일 타입 체크

		System.out.println();
		System.out.println("*********************************");
		System.out.println("Fasoo 복호화 진행 중");
		System.out.println("Fasoo orgin FilePath : " + ORGFileDir + FileRealName);
		System.out.println("Fasoo target FilePath : " + DRMFileDir + Filename);
		System.out.println("파일형태 : " + FileTypeStr(iBret) + " / fileType :" + iBret);
		System.out.println("*********************************");
		System.out.println();

		// 1. Fasoo 암호화 문서(FSN또는 FSD)일 경우 복호화
		if (iBret == 26 || iBret == 103) {
			boolean bRet = false;
			bRet = oWorkPackager.DoExtract(drm_fsdinit_path, fsn_domain_id, ORGFileDir + FileRealName,
					DRMFileDir + Filename);
			error_num = oWorkPackager.getLastErrorNum();
			error_str = oWorkPackager.getLastErrorStr();

			if (error_num != 0) {

				System.out.println();
				System.out.println("*********************************");
				System.out.println("Fasoo 복호화 진행 불가");
				System.out.println("error_num = ? " + error_num);
				System.out.println("error_str = ?[ " + error_str + " ]");
				System.out.println("*********************************");
				System.out.println();

				Error_Check = 1;
				Error_Message = "DRM_PKGING_ERROR";
			} else {
				int iBret2 = oWorkPackager.GetFileType(DRMFileDir + Filename); // 파일 타입 체크

				System.out.println();
				System.out.println("*********************************");
				System.out.println("Fasoo 복호화 진행 완료");
				System.out.println("파일형태 : " + FileTypeStr(iBret2) + " / fileType :" + iBret2);
				System.out.println("*********************************");
				System.out.println();

			}
			// 2. Fasoo 암호화 문서(FSN또는 FSD)가 아닐 경우 Pass
		} else {
			Error_Check = 1;
			Error_Message = "NOT Support File";
		}
		return returnValue;
	}

	/* DRM 암호화 작업 */
	public static String download(HashMap drmInfoMap) throws ExceptionUtil {
		System.out.println("FASOO_SKON == download");
		String returnValue = "";

		boolean bret = false;
		boolean nret = false;
		boolean iret = false;
		int fileType = 0;
		try {
			String fsdinit = DrmGlobalVal.DRM_FASOO_MODULE_PATH;
			String dsdcode = DrmGlobalVal.DRM_FASOO_KEY_ID;

			String FileRealName = StringUtil.checkNull(drmInfoMap.get("orgFileName"), "");
			String orgfile = StringUtil.checkNull(drmInfoMap.get("downFile"), "");
			String targetfile = StringUtil.checkNull(drmInfoMap.get("targetFile"), "");

			String userID = StringUtil.checkNull(drmInfoMap.get("userID"), "");
			String userName = StringUtil.checkNull(drmInfoMap.get("userName"), "");
			String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"), "");
			String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"), "");

			WorkPackager wPackager = new WorkPackager();
			
			wPackager.setOverWriteFlag(true);

			// 01.암호화 대상 문서가 지원 가능 확장자인지 확인
			nret = wPackager.IsSupportFile(fsdinit, // fsdinit 폴더 FullPath 설정
					dsdcode, // 고객사 Key(default)
					orgfile // 복호화 대상 문서 FullPath + FileName
			);
			System.out.println("암호화 가능 여부 : " + nret);
			// 02.대상 파일의 암호화 여부 확인
			fileType = wPackager.GetFileType(orgfile);

			System.out.println();
			System.out.println("*********************************");
			System.out.println("Fasoo 암호화 진행 중");
			System.out.println("Fasoo orgin FilePath : " + orgfile);
			System.out.println("Fasoo target FilePath : " + targetfile);
			System.out.println("파일형태 : " + FileTypeStr(fileType) + " / fileType :" + fileType);
			System.out.println("*********************************");
			System.out.println();

			// 03.대상 문서가 비 암호화 문서 이며 지원 가능 확장자 일때 암호화 진행
			if (fileType == 29) {
				iret = wPackager.DoPackagingFsn2(fsdinit, // fsdinit 폴더 FullPath 설정
						dsdcode, // 고객사 Key(default) , 계열사에 맞는 DSD코드 입력
						orgfile, // 암호화 대상 문서 FullPath + FileName
						targetfile, // 암호화 된 문서 FullPath + FileName
						FileRealName, // 파일 명
						userID, // 신청자 ID
						userName, // 신청자 명
						userID, userName, teamID, teamName, // 신청자 ID, 신청자 명, 부서코드, 부서명
						userID, userName, teamID, teamName, // 신청자 ID, 신청자 명, 부서코드, 부서명
						DrmGlobalVal.DRM_FASOO_SECURITY_CODE // 그룹 공통 코드
				);

				System.out.println("암호화 결과값 : " + iret);

				if (iret) {
					returnValue = targetfile;

					int iret2 = wPackager.GetFileType(targetfile); // 파일 타입 체크

					System.out.println();
					System.out.println("*********************************");
					System.out.println("Fasoo 암호화 진행 완료");
					System.out.println("파일형태 : " + FileTypeStr(iret2) + " / fileType :" + iret2);
					System.out.println("*********************************");
					System.out.println();

				} else {

					System.out.println();
					System.out.println("*********************************");
					System.out.println("Fasoo 암호화 실패");
					System.out.println("오류코드 : " + wPackager.getLastErrorNum());
					System.out.println("오류값 : " + wPackager.getLastErrorStr());
					System.out.println("*********************************");
					System.out.println();

				}
			}
			System.out.println("returnValue : " + returnValue);

		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return returnValue;
	}

	/* DRM 복호화 작업 */
	public static String view(HashMap drmInfoMap) throws ExceptionUtil {

		System.out.println("FASOO_SKON == view");
		String returnValue = "";

		String drm_fsdinit_path = DrmGlobalVal.DRM_FASOO_MODULE_PATH;
		String fsn_domain_id = DrmGlobalVal.DRM_FASOO_KEY_ID; // 고유 코드
		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "");
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"), "");
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");

		System.out.println("drm_fsdinit_path :" + drm_fsdinit_path);
		System.out.println("fsn_domain_id :" + fsn_domain_id);

		String sErrMessage = "";
		int error_num = 0;
		String error_str = "";
		int Error_Check = 0;
		String Error_Message = "";

		WorkPackager oWorkPackager = new WorkPackager();
		oWorkPackager.setOverWriteFlag(true);

		int iBret = 0;

		iBret = oWorkPackager.GetFileType(ORGFileDir + FileRealName); // 파일 타입 체크

		System.out.println();
		System.out.println("*********************************");
		System.out.println("Fasoo 복호화 진행 중");
		System.out.println("Fasoo orgin FilePath : " + ORGFileDir + FileRealName);
		System.out.println("Fasoo target FilePath : " + DRMFileDir + Filename);
		System.out.println("파일형태 : " + FileTypeStr(iBret) + " / fileType :" + iBret);
		System.out.println("*********************************");
		System.out.println();

		// 1. Fasoo 암호화 문서(FSN또는 FSD)일 경우 복호화
		if (iBret == 26 || iBret == 103) {
			boolean bRet = false;
			bRet = oWorkPackager.DoExtract(drm_fsdinit_path, fsn_domain_id, ORGFileDir + FileRealName,
					DRMFileDir + Filename);
			error_num = oWorkPackager.getLastErrorNum();
			error_str = oWorkPackager.getLastErrorStr();

			if (error_num != 0) {

				System.out.println();
				System.out.println("*********************************");
				System.out.println("Fasoo 복호화 진행 불가");
				System.out.println("error_num = ? " + error_num);
				System.out.println("error_str = ?[ " + error_str + " ]");
				System.out.println("*********************************");
				System.out.println();

				Error_Check = 1;
				Error_Message = "DRM_PKGING_ERROR";
			} else {
				int iBret2 = oWorkPackager.GetFileType(DRMFileDir + Filename); // 파일 타입 체크

				System.out.println();
				System.out.println("*********************************");
				System.out.println("Fasoo 복호화 진행 완료");
				System.out.println("파일형태 : " + FileTypeStr(iBret2) + " / fileType :" + iBret2);
				System.out.println("*********************************");
				System.out.println();

			}
			// 2. Fasoo 암호화 문서(FSN또는 FSD)가 아닐 경우 Pass
		} else {
			Error_Check = 1;
			Error_Message = "NOT Support File";
		}
		return returnValue;
	}

	public static Map report(HashMap drmInfoMap) throws ExceptionUtil {
		Map returnMap = new HashMap();

		boolean bret = false;
		boolean nret = false;
		boolean iret = false;
		int fileType = 0;
		try {
			String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"), "");
			if (filePath.equals("")) {
				filePath = FileUtil.FILE_EXPORT_DIR;
			}

			String fsdinit = filePath;
			String dsdcode = DrmGlobalVal.DRM_FASOO_KEY_ID;

			String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName2
			String filename_tar = StringUtil.checkNull(drmInfoMap.get("orgFileName")); // orgFileName2
			String orgfile = StringUtil.checkNull(drmInfoMap.get("downFile")); // downFile2
			String targetfile = filePath + filename_tar;
			String securitycode = "1"; // 그룹한 등급

			String userID = StringUtil.checkNull(drmInfoMap.get("userID"));
			String userName = StringUtil.checkNull(drmInfoMap.get("userName"));
			String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"));
			String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"));

			WorkPackager wPackager = new WorkPackager();

			// 01.암호화 대상 문서가 지원 가능 확장자인지 확인
			nret = wPackager.IsSupportFile(fsdinit, // fsdinit 폴더 FullPath 설정
					dsdcode, // 고객사 Key(default)
					orgfile // 복호화 대상 문서 FullPath + FileName
			);
			// 02.대상 파일의 암호화 여부 확인
			fileType = wPackager.GetFileType(orgfile);

			// 03.대상 문서가 비 암호화 문서 이며 지원 가능 확장자 일때 암호화 진행
			if (fileType == 29) {
				iret = wPackager.DoPackagingFsn2(fsdinit, // fsdinit 폴더 FullPath 설정
						dsdcode, // 고객사 Key(default) , 계열사에 맞는 DSD코드 입력
						orgfile, // 암호화 대상 문서 FullPath + FileName
						targetfile, // 암호화 된 문서 FullPath + FileName
						filename_org, // 파일 명
						userID, // 신청자 ID
						userName, // 신청자 명
						userID, userName, teamID, teamName, // 신청자 ID, 신청자 명, 부서코드, 부서명
						userID, userName, teamID, teamName, // 신청자 ID, 신청자 명, 부서코드, 부서명
						"1" // 그룹 공통 코드
				);

				System.out.println("암호화 결과값 : " + iret);
				System.out.println("오류코드 : " + wPackager.getLastErrorNum());
				System.out.println("오류값 : " + wPackager.getLastErrorStr());
			}

			returnMap.put("fileType", fileType);
			returnMap.put("drmResultData", iret);
			returnMap.put("errNum", wPackager.getLastErrorNum());
			returnMap.put("errData", wPackager.getLastErrorStr());
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return returnMap;
	}

	public static String FileTypeStr(int i) {
		String ret = null;
		switch (i) {
		case 20:
			ret = "파일을 찾을 수 없습니다.";
			break;
		case 21:
			ret = "파일 사이즈가 0 입니다.";
			break;
		case 22:
			ret = "파일을 읽을 수 없습니다.";
			break;
		case 26:
			ret = "FSD 파일입니다.";
			break;
		case 29:
			ret = "암호화 파일이 아닙니다.";
			break;
		case 82:
			ret = "등록되지 않은 MAC 주소입니다.";
			break;
		case 105:
			ret = "Wrapsody 파일입니다.";
			break;
		case 106:
			ret = "NX 파일입니다.";
			break;
		case 101:
			ret = "MarkAny 파일입니다.";
			break;
		case 104:
			ret = "INCAPS 파일입니다.";
			break;
		case 103:
			ret = "FSN 파일입니다.";
			break;
		case 1192:
			ret = "SOFTCAMP 파일입니다.";
			break;
		}
		return ret;
	}

	public static boolean isFasooFile(String fileFullPath) {

		WorkPackager oWorkPackager = new WorkPackager();

		return oWorkPackager.IsPackageFile(fileFullPath);
	}

	public static Hashtable getFileHeader(String filePath) {

		WorkPackager oWorkPackager = new WorkPackager();

		Hashtable headerInfo = oWorkPackager.GetFileHeader(filePath);
		String docLevel = StringUtil.checkNull(headerInfo.get("misc2-info"));

		System.out.println();
		System.out.println("FASOO HEADER 값 : " + docLevel);
		System.out.println();

		return headerInfo;

	}

}
