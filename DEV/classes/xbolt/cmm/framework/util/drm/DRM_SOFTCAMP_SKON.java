package xbolt.cmm.framework.util.drm;

import java.util.HashMap;

import SCSL.SLBsUtil;
import SCSL.SLDsEncDecHeader;
import SCSL.SLDsFile;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;

public class DRM_SOFTCAMP_SKON {
	public static String upload(HashMap drmInfoMap) throws ExceptionUtil {

		System.out.println("SOFTCAMP_SKON == upload");

		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "");
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"), "");
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");
		String userID = StringUtil.checkNull(drmInfoMap.get("userID"), "");
		String userName = StringUtil.checkNull(drmInfoMap.get("userName"), "");
		String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"), "");
		String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"), "");

		SLDsFile sFile = new SLDsFile();
		sFile.SettingPathForProperty(DrmGlobalVal.DRM_SOFTCAMP_MODULE_PATH);

		// 암호화 여부 체크
		SLBsUtil slbsUtil = new SLBsUtil();
		String orgFilePath = ORGFileDir.replace("//", "\\").replace("/", "\\") + FileRealName;
		int encryptVal = slbsUtil.isEncryptFile(orgFilePath);

		System.out.println();
		System.out.println("*********************************");
		System.out.println("SoftCamp 암호화 진행 중");
		System.out.println("SoftCamp orgin FilePath : " + orgFilePath);
		System.out.println("SoftCamp target FilePath : " + DRMFileDir + Filename);
		System.out.println("*********************************");
		System.out.println();

		if (encryptVal == 1) {
			System.out.println();
			System.out.println("*********************************");
			System.out.println("SoftCamp 암호화 진행 불가");
			System.out.println("*********************************");
			System.out.println();
			return DRMFileDir + Filename;
		} else {
			int ret;
			ret = sFile.DSSLDocuGradeEncAddCreator("C:\\softcamp\\04_KeyFile\\keyGrade_SVR0.sc", "System", "none",
					"0000006", "SECURITYDOMAIN", "SECURITYDOMAIN;", "none", orgFilePath, DRMFileDir + Filename,
					"SECURITYDOMAIN", "SECURITYDOMAIN;", DrmGlobalVal.DRM_SOFTCAMP_KEY, 1, 0);

			System.out.println();
			System.out.println("*********************************");
			System.out.println("SoftCamp 암호화 진행 완료");
			System.out.println("DSSLDocuGradeEncAddCreator [" + ret + "]");
			System.out.println("*********************************");
			System.out.println();

			return StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + "//" + Filename;
		}

	}

	public static String download(HashMap drmInfoMap) throws ExceptionUtil {

		System.out.println("SOFTCAMP_SKON == download");

		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("downFile"), "").replace("//", "\\").replace("/", "\\");
		String DRMFileDir = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH).replace("//", "\\").replace("/",
				"\\") + "\\";
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("orgFileName"), "");
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
		String userID = StringUtil.checkNull(drmInfoMap.get("userID"), "");
		String userName = StringUtil.checkNull(drmInfoMap.get("userName"), "");
		String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"), "");
		String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"), "");

		SLDsFile sFile = new SLDsFile();
		sFile.SettingPathForProperty(DrmGlobalVal.DRM_SOFTCAMP_MODULE_PATH);
		sFile.SLDsInitDAC();
		sFile.SLDsAddUserDAC("SECURITYDOMAIN", "111001100", 0, 0, 0);

		// 문서 등급 별 다운로드
		String orgFilePath = ORGFileDir.replace("//", "\\").replace("/", "\\");
		SLDsEncDecHeader dsEncDecHeader = new SLDsEncDecHeader();
		byte[] gradeID = new byte[22];

		int gradeRet = dsEncDecHeader.DSGetDocuGradeDocument(orgFilePath, gradeID);
		String strGradeID = new String(gradeID, 2, 20);
		;

		System.out.println();
		System.out.println("*********************************");
		System.out.println("SoftCamp 복호화 진행 중");
		System.out.println("SoftCamp orgin FilePath : " + orgFilePath);
		System.out.println("SoftCamp target FilePath : " + DRMFileDir + FileRealName);
		System.out.println("*********************************");
		System.out.println();

		if ((strGradeID.trim()).equals("0000007") || (strGradeID.trim()).equals("0000008")) {

			System.out.println();
			System.out.println("*********************************");
			System.out.println("SoftCamp 복호화 진행 불가");
			System.out.println("문서등급 : " + strGradeID.trim());
			System.out.println("*********************************");
			System.out.println();

			throw new ExceptionUtil("접근 권한 없음");

		} else {

			int retVal = sFile.CreateDecryptFileDAC(DrmGlobalVal.DRM_SOFTCAMP_KEY, "SECURITYDOMAIN", orgFilePath,
					DRMFileDir.replace("//", "\\").replace("/", "\\") + FileRealName);

			System.out.println();
			System.out.println("*********************************");
			System.out.println("SoftCamp 복호화 진행 완료");
			System.out.println("CreateDecryptFileDAC [" + retVal + "]");
			System.out.println("*********************************");
			System.out.println();

			return DRMFileDir + FileRealName;

			/*
			 * int ret = sFile.DSSLDocuGradeEncAddCreator(
			 * "C:\\softcamp\\04_KeyFile\\keyGrade_SVR0.sc", "System", "none", "0000006",
			 * "SECURITYDOMAIN", "SECURITYDOMAIN;", "none", orgFilePath, DRMFileDir +
			 * FileRealName, "SECURITYDOMAIN", "SECURITYDOMAIN;",
			 * DrmGlobalVal.DRM_SOFTCAMP_KEY, 0, 1);
			 * 
			 * System.out.println("DSSLDocuGradeEncAddCreator [" + ret + "]");
			 * System.out.println("SoftCamp 복호화 진행 중");
			 * System.out.println("*********************************");
			 * 
			 * return DRMFileDir + FileRealName;
			 */
		}
	}

	public static String view(HashMap drmInfoMap) throws ExceptionUtil {

		System.out.println("SOFTCAMP_SKON == view");

		String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "");
		String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"), "");
		String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
		String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");
		String userID = StringUtil.checkNull(drmInfoMap.get("userID"), "");
		String userName = StringUtil.checkNull(drmInfoMap.get("userName"), "");
		String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"), "");
		String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"), "");

		SLDsFile sFile = new SLDsFile();
		sFile.SettingPathForProperty(DrmGlobalVal.DRM_SOFTCAMP_MODULE_PATH);

		// 문서 등급 별 view 추가
		String orgFilePath = ORGFileDir.replace("//", "\\").replace("/", "\\") + FileRealName;
		SLDsEncDecHeader dsEncDecHeader = new SLDsEncDecHeader();
		byte[] gradeID = new byte[22];

		int ret = dsEncDecHeader.DSGetDocuGradeDocument(orgFilePath, gradeID);
		String strGradeID = new String(gradeID, 2, 20);

		System.out.println();
		System.out.println("*********************************");
		System.out.println("SoftCamp 복호화 진행 중");
		System.out.println("SoftCamp orgin FilePath : " + orgFilePath);
		System.out.println("SoftCamp target FilePath : " + DRMFileDir + FileRealName);
		System.out.println("*********************************");
		System.out.println();

		if ((strGradeID.trim()).equals("0000007") || (strGradeID.trim()).equals("0000008")) {

			System.out.println();
			System.out.println("*********************************");
			System.out.println("SoftCamp 복호화 진행 불가");
			System.out.println("문서등급 : " + strGradeID.trim());
			System.out.println("*********************************");
			System.out.println();

			throw new ExceptionUtil("접근 권한 없음");
		} else {
			int retVal = sFile.CreateDecryptFileDAC(DrmGlobalVal.DRM_SOFTCAMP_KEY, "SECURITYDOMAIN", orgFilePath,
					DRMFileDir.replace("//", "\\").replace("/", "\\") + Filename);

			System.out.println();
			System.out.println("*********************************");
			System.out.println("SoftCamp 복호화 진행 완료");
			System.out.println("CreateDecryptFileDAC [" + retVal + "]");
			System.out.println("*********************************");
			System.out.println();

			return DRMFileDir + Filename;
		}

	}

	public static String report(HashMap drmInfoMap) throws ExceptionUtil {

		String returnValue = "";

		try {
			String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"), "");
			if (filePath.equals("")) {
				filePath = FileUtil.FILE_EXPORT_DIR;
			}

			String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName"));
			String userID = StringUtil.checkNull(drmInfoMap.get("userID"), "");

			SLDsFile sFile = new SLDsFile();
			sFile.SettingPathForProperty(DrmGlobalVal.DRM_SOFTCAMP_MODULE_PATH);
			sFile.SLDsInitDAC();
			sFile.SLDsAddUserDAC("SECURITYDOMAIN", "111001100", 0, 0, 0);

			int ret;
			ret = sFile.SLDsEncFileDACV2(DrmGlobalVal.DRM_SOFTCAMP_KEY, "System",
					filePath.replace("//", "\\").replace("/", "\\") + filename_org,
					StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH).replace("//", "\\").replace("/", "\\")
							+ "\\" + filename_org,
					0);

			System.out.println("SLDsEncFileDAC :" + ret);
			returnValue = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + "//" + filename_org;

		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return returnValue;
	}
}
